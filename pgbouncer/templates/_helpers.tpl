{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "pgbouncer.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pgbouncer.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pgbouncer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "pgbouncer.labels" -}}
app.kubernetes.io/name: {{ include "pgbouncer.name" . }}
helm.sh/chart: {{ include "pgbouncer.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "pgbouncer.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "pgbouncer.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get secret
*/}}
{{- define "getSecret" -}}
{{- $obj := (lookup "v1" "Secret" "default" .Name).data -}}
{{- if $obj -}}
    {{ index $obj .Key | b64dec }}
{{- end -}}
{{- end -}}

{{/*
Generate database list
*/}}
{{- define "databaseList" -}}
{{- $strlist := list }}
{{- range $v := .Values.databases -}}
    {{- $dblist := list }}
    {{- $pgbName := "" }}
    {{- range $k, $vv := $v }}
        {{- if eq $k "secret" }}
            {{- $dblist = printf "%s=%s" "password" (include "getSecret" (dict "Name" $vv.name "Key" $vv.key)) | append $dblist }}
        {{- else if eq $k "password" }}
            {{- $dblist = printf "%s=%s" $k $vv | append $dblist }}
        {{- else if eq $k "pgbName" }}
            {{- $pgbName = $vv }}
        {{- else }}
            {{- $dblist = printf "%s=%s" $k $vv | append $dblist }}
        {{- end -}}
    {{- end -}}
    {{- $dbstr := $dblist | join " " }}
    {{- $strlist = printf "%s = %s" $pgbName $dbstr | append $strlist}}
{{- end -}}
{{ $strlist | join "," }}
{{- end -}}
