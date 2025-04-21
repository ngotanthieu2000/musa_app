import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

// Import sử dụng barrel files
import '../../../../core/index.dart';
import '../../domain/entities/profile.dart';
import '../bloc/profile_bloc.dart';

class EditProfilePage extends StatefulWidget {
  final Profile profile;
  
  const EditProfilePage({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  File? _imageFile;
  bool _uploading = false;
  bool _imageChanged = false;
  bool _isSubmitting = false;
  
  @override
  void initState() {
    super.initState();
    _initControllers();
  }
  
  void _initControllers() {
    _nameController = TextEditingController(text: widget.profile.name ?? '');
    _emailController = TextEditingController(text: widget.profile.email ?? '');
    _phoneController = TextEditingController(text: widget.profile.phoneNumber ?? '');
    _bioController = TextEditingController(text: widget.profile.bio ?? '');
  }
  
  @override
  void didUpdateWidget(EditProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.profile != oldWidget.profile) {
      // Cập nhật controllers với dữ liệu mới
      _disposeControllers();
      _initControllers();
    }
  }
  
  void _disposeControllers() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
  }
  
  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }
  
  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _uploading = true;
      });
      
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _imageChanged = true;
          _uploading = false;
        });
      } else {
        setState(() {
          _uploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _uploading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể chọn ảnh: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Chọn từ thư viện'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Chụp ảnh mới'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate() && !_isSubmitting) {
      setState(() {
        _isSubmitting = true;
      });
      
      // Chuẩn bị dữ liệu profile để gửi đi
      Map<String, dynamic> updatedProfile = {
        'id': widget.profile.id, // Đảm bảo có ID
        'name': _nameController.text,
        'email': _emailController.text,
        'phone_number': _phoneController.text,
        'bio': _bioController.text,
      };
      
      // Nếu có ảnh mới, thêm vào form data
      if (_imageChanged && _imageFile != null) {
        updatedProfile['avatar_file'] = _imageFile!.path;
      }
      
      // Gửi sự kiện cập nhật profile
      context.read<ProfileBloc>().add(
        UpdateProfileEvent(profile: updatedProfile),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chỉnh sửa hồ sơ',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.primary),
          onPressed: () => context.pop(),
        ),
        backgroundColor: colorScheme.background,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submitForm,
            child: Text(
              'Lưu',
              style: textTheme.labelLarge?.copyWith(
                color: _isSubmitting ? colorScheme.primary.withOpacity(0.5) : colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            setState(() {
              _isSubmitting = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ProfileLoaded) {
            // Kiểm tra nếu profile vừa được cập nhật
            if (widget.profile.id == state.profile.id && 
                (widget.profile.updatedAt == null || 
                state.profile.updatedAt != null && 
                state.profile.updatedAt!.isAfter(widget.profile.updatedAt!))) {
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Hồ sơ đã được cập nhật thành công'),
                  backgroundColor: Colors.green,
                ),
              );
              
              // Đóng màn hình edit-profile sau khi cập nhật thành công
              // và trở về trang profile để hiển thị dữ liệu mới
              Future.delayed(const Duration(milliseconds: 800), () {
                if (mounted) {
                  // Quay về trang profile
                  context.go('/profile');
                }
              });
            }
          }
        },
        builder: (context, state) {
          // Hiển thị loading indicator nếu đang tải
          if (state is ProfileLoading || _isSubmitting) {
            return const Center(
              child: LoadingIndicator(
                message: 'Đang cập nhật hồ sơ...',
              ),
            );
          }
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Image Section
                    Center(
                      child: Stack(
                        children: [
                          // Avatar
                          _uploading
                              ? const CircularProgressIndicator()
                              : Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colorScheme.primary.withOpacity(0.5),
                                      width: 3,
                                    ),
                                    color: colorScheme.primaryContainer,
                                  ),
                                  child: ClipOval(
                                    child: _imageFile != null
                                        ? Image.file(
                                            _imageFile!,
                                            fit: BoxFit.cover,
                                          )
                                        : widget.profile.avatar != null &&
                                                widget.profile.avatar!.isNotEmpty
                                            ? Image.network(
                                                widget.profile.avatar!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, _) =>
                                                    _buildDefaultAvatar(textTheme, colorScheme),
                                              )
                                            : _buildDefaultAvatar(textTheme, colorScheme),
                                  ),
                                ),
                          
                          // Edit button
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: _showImageSourceActionSheet,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: colorScheme.background,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Fullname field with validation
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Họ tên',
                        hintText: 'Nhập họ tên của bạn',
                        prefixIcon: Icon(Icons.person_outline, color: colorScheme.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập họ tên';
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    
                    // Email field with validation
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Nhập địa chỉ email của bạn',
                        prefixIcon: Icon(Icons.email_outlined, color: colorScheme.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập email';
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Email không hợp lệ';
                        }
                        return null;
                      },
                      enabled: false, // Email không thể chỉnh sửa
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    
                    // Phone field with validation
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Số điện thoại',
                        hintText: 'Nhập số điện thoại của bạn',
                        prefixIcon: Icon(Icons.phone_outlined, color: colorScheme.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return null; // Số điện thoại là tùy chọn
                        } else if (!RegExp(r'^\+?[0-9]{10,12}$').hasMatch(value)) {
                          return 'Số điện thoại không hợp lệ';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    
                    // Bio field - optional
                    TextFormField(
                      controller: _bioController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Giới thiệu',
                        hintText: 'Viết một vài dòng về bạn',
                        alignLabelWithHint: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 64),
                          child: Icon(Icons.description_outlined, color: colorScheme.primary),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 32),
                    
                    // Submit button
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isSubmitting 
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Cập nhật hồ sơ',
                              style: textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildDefaultAvatar(TextTheme textTheme, ColorScheme colorScheme) {
    return Center(
      child: Text(
        _nameController.text.isNotEmpty
            ? _nameController.text.substring(0, 1).toUpperCase()
            : '?',
        style: textTheme.headlineLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 