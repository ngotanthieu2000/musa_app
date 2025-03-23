class EnvConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://8080-idx-homeappbe-1742142773201.cluster-3g4scxt2njdd6uovkqyfcabgo6.cloudworkstations.dev/api/v1',
  );
} 