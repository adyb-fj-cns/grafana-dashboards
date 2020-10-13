local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;

dashboard.new(
  'Jenkins Pipeline - Empty',
  tags=['jenkins']  
)