{{- define "mariadb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "mariadb.fullname" -}}
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

{{- define "mariadb.namespace" -}}
{{- .Values.namespaceOverride | default .Release.Namespace }}
{{- end }}

{{- define "mariadb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "mariadb.labels" -}}
helm.sh/chart: {{ include "mariadb.chart" . }}
{{ include "mariadb.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{- define "mariadb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mariadb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mariadb.image" -}}
{{- $registry := .Values.global.imageRegistry | default .Values.image.registry -}}
{{- $repository := .Values.image.repository -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- if .Values.image.digest }}
{{- printf "%s/%s@%s" $registry $repository .Values.image.digest }}
{{- else }}
{{- printf "%s/%s:%s" $registry $repository $tag }}
{{- end }}
{{- end }}

{{- define "mariadb.secretName" -}}
{{- if .Values.auth.existingSecret }}
{{- .Values.auth.existingSecret }}
{{- else }}
{{- include "mariadb.fullname" . }}
{{- end }}
{{- end }}

{{- define "mariadb.rootPasswordKey" -}}
{{- .Values.auth.secretKeys.rootPasswordKey | default "mariadb-root-password" }}
{{- end }}

{{- define "mariadb.userPasswordKey" -}}
{{- .Values.auth.secretKeys.userPasswordKey | default "mariadb-password" }}
{{- end }}

{{- define "mariadb.rootPassword" -}}
{{- if .Values.global.mariadb.auth.rootPassword }}
{{- .Values.global.mariadb.auth.rootPassword }}
{{- else }}
{{- .Values.auth.rootPassword | default (randAlphaNum 10) }}
{{- end }}
{{- end }}

{{- define "mariadb.username" -}}
{{- .Values.global.mariadb.auth.username | default .Values.auth.username }}
{{- end }}

{{- define "mariadb.userPassword" -}}
{{- if .Values.global.mariadb.auth.password }}
{{- .Values.global.mariadb.auth.password }}
{{- else }}
{{- .Values.auth.password | default (randAlphaNum 10) }}
{{- end }}
{{- end }}

{{- define "mariadb.database" -}}
{{- .Values.global.mariadb.auth.database | default .Values.auth.database }}
{{- end }}

{{- define "mariadb.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mariadb.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "mariadb.servicePort" -}}
{{- .Values.global.mariadb.service.ports.mariadb | default .Values.primary.service.ports.mariadb }}
{{- end }}

{{- define "mariadb.resources" -}}
{{- $preset := .preset -}}
{{- if eq $preset "nano" }}
requests:
  cpu: 100m
  memory: 128Mi
limits:
  cpu: 150m
  memory: 256Mi
{{- else if eq $preset "micro" }}
requests:
  cpu: 250m
  memory: 256Mi
limits:
  cpu: 500m
  memory: 512Mi
{{- else if eq $preset "small" }}
requests:
  cpu: 500m
  memory: 512Mi
limits:
  cpu: "1"
  memory: 1Gi
{{- end }}
{{- end }}
