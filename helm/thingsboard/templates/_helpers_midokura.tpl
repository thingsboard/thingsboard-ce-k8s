{{/*
Add Bitnami-like affinity sections
{{- include "midokura.affinity" (dict "service" .Values.someservice "podLabels" $podLabels "context" $) | nindent 6 }}
*/}}
{{- define "midokura.affinity" -}}
{{- $context := .context -}}
{{- $podLabels := .podLabels -}}
{{- with .service -}}
{{- if .affinity }}
affinity: {{- include "common.tplvalues.render" (dict "value" .affinity "context" $) | nindent 2 }}
{{- end }}
{{- if or .podAffinityPreset .podAntiAffinityPreset .nodeAffinityPreset -}}
affinity:
  {{- if .podAffinityPreset }}
  podAffinity: {{- include "common.affinities.pods" (dict "type" .podAffinityPreset "customLabels" $podLabels "context" $context) | nindent 4 }}
  {{- end }}
  {{- if .podAntiAffinityPreset }}
  podAntiAffinity: {{- include "common.affinities.pods" (dict "type" .podAntiAffinityPreset "customLabels" $podLabels "context" $context) | nindent 4 }}
  {{- end }}
  {{- if .nodeAffinityPreset }}
  nodeAffinity: {{- include "common.affinities.nodes" (dict "type" .nodeAffinityPreset.type "key" .nodeAffinityPreset.key "values" .nodeAffinityPreset.values) | nindent 4 }}
  {{- end }}
{{- end -}}
{{- end -}}
{{- end -}}

