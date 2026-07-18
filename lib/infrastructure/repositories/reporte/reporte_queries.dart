const String cteUltimos6Meses = '''
  WITH RECURSIVE meses(mes) AS (
    SELECT strftime('%Y-%m', 'now', '-6 months')
    UNION ALL
    SELECT strftime('%Y-%m', mes || '-01', '+1 month')
    FROM meses
    WHERE mes < strftime('%Y-%m', 'now')
  )
''';
