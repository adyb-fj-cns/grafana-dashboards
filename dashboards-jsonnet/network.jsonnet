local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local singlestat = grafana.singlestat;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local traffic =
  graphPanel.new(
    title='Network traffic on eth0',
    datasource='Prometheus',
    linewidth=2,
    format='Bps',
    aliasColors={
      Rx: 'light-green',
      Tx: 'light-red',
    },
  ).addTarget(
    prometheus.target(
      'rate(node_network_receive_bytes_total{idevice="eth0", job="$job"}[1m])',
      legendFormat='Rx',
    )
  ).addTarget(
    prometheus.target(
      'irate(node_network_transmit_bytes_total{device="eth0", job="$job"}[1m]) * (-1)',
      legendFormat='Tx',
    )
  );

dashboard.new(
  'Jenkins Pipeline - Network',
  tags=['prometheus'],
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
    'job',
    '$PROMETHEUS_DS',
    'label_values(node_network_receive_bytes_total, job)',
    label='Job',
    refresh='time',
  )
)
.addPanels(
  [
    traffic { gridPos: { h: 8, w: 20, x: 0, y: 4 } },   
  ]
)
