{{/*

Copyright © 2016-2020 The Thingsboard Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/}}

{{/*
Set the value of cassandra initdb configmap
*/}}
{{- if .Values.cassandra.enabled }}
{{- $_ := set .Values.cassandra "initDBConfigMap"  "{{ .Release.Name }}-cassandra-init-db" }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "thingsboard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "thingsboard.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "thingsboard.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "thingsboard.labels" -}}
helm.sh/chart: {{ include "thingsboard.chart" . }}
{{ include "thingsboard.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "thingsboard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "thingsboard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: Thingsboard
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- define "thingsboard.selectorLabels-node" -}}
app.kubernetes.io/name: {{ include "thingsboard.name" . }}-node
app.kubernetes.io/instance: {{ .Release.Name }}-node

{{- end }}
{{- define "thingsboard.selectorLabels-mqtt" -}}
app.kubernetes.io/name: {{ include "thingsboard.name" . }}-mqtt
app.kubernetes.io/instance: {{ .Release.Name }}-mqtt

{{- end }}
{{- define "thingsboard.selectorLabels-http" -}}
app.kubernetes.io/name: {{ include "thingsboard.name" . }}-http
app.kubernetes.io/instance: {{ .Release.Name }}-http
{{- end }}
{{- define "thingsboard.selectorLabels-coap" -}}
app.kubernetes.io/name: {{ include "thingsboard.name" . }}-coap
app.kubernetes.io/instance: {{ .Release.Name }}-coap
{{- end }}
{{- define "thingsboard.selectorLabels-jsexecutor" -}}
app.kubernetes.io/name: {{ include "thingsboard.name" . }}-jsexecutor
app.kubernetes.io/instance: {{ .Release.Name }}-jsexecutor
{{- end }}
{{- define "thingsboard.selectorLabels-webui" -}}
app.kubernetes.io/name: {{ include "thingsboard.name" . }}-webui
app.kubernetes.io/instance: {{ .Release.Name }}-webui
{{- end }}
{{- define "thingsboard.selectorLabels-rule-engine" -}}
app.kubernetes.io/name: {{ include "thingsboard.name" . }}-rule-engine
app.kubernetes.io/instance: {{ .Release.Name }}-rule-engine
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "thingsboard.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "thingsboard.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
