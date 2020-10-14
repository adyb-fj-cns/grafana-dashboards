local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local singlestat = grafana.singlestat;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local crashLoopBackOff =
  graphPanel.new(
    title='Crashloopbackoff',
    datasource='Prometheus',
    linewidth=2,
    format='Bps',
  ).addTarget(
    prometheus.target(
      'increase(kube_pod_container_status_restarts_total{namespace="$namespace",container="$container"}[60m]) > 0'
    )
  );

dashboard.new(
  'Jenkins Pipeline - CrashLoopBackOff',
  tags=['jenkins'],
  schemaVersion=18,
  editable=true,
  time_from='now-1h',
  refresh='1m',
)
.addTemplate(
  template.datasource(
    'PROMETHEUS_DS',
    'prometheus',
    'Prometheus',
    hide='label',
  )
)
.addTemplate(
  template.new(
    'namespace',
    '$PROMETHEUS_DS',
    'label_values(kube_pod_container_status_restarts_total, namespace)',
    label='Namespace',
    refresh='time',
  )
)
.addTemplate(
  template.new(
    'container',
    '$PROMETHEUS_DS',
    'label_values(kube_pod_container_status_restarts_total, container)',
    label='Container',
    refresh='time',
  )
)
.addPanels(
  [
    crashLoopBackOff { gridPos: { h: 8, w: 20, x: 0, y: 4 } },   
  ]
)
