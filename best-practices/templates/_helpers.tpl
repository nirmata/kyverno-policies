{{/* vim: set filetype=mustache: */}}
{{/* Expand the name of the chart. */}}
{{- define "best-practices-policies.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Create chart name and version as used by the chart label. */}}
{{- define "best-practices-policies.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Helm required labels */}}
{{- define "best-practices-policies.labels" -}}
app.kubernetes.io/component: kyverno
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: {{ template "best-practices-policies.name" . }}
app.kubernetes.io/part-of: {{ template "best-practices-policies.name" . }}
app.kubernetes.io/version: "{{ .Chart.Version }}"
helm.sh/chart: {{ template "best-practices-policies.chart" . }}
{{- if .Values.customLabels }}
{{ toYaml .Values.customLabels }}
{{- end }}
{{- end -}}


{{/* Get deployed Kyverno version from Kubernetes */}}
{{- define "best-practices-policies.kyvernoVersion" -}}
{{- $version := "" -}}
{{- if eq .Values.kyvernoVersion "autodetect" }}
{{- with (lookup "apps/v1" "Deployment" .Release.Namespace "kyverno") -}}
  {{- with (first .spec.template.spec.containers) -}}
    {{- $imageTag := (last (splitList ":" .image)) -}}
    {{- $version = trimPrefix "v" $imageTag -}}
  {{- end -}}
{{- end -}}
{{ $version }}
{{- else -}}
{{ .Values.kyvernoVersion }}
{{- end -}}
{{- end -}}

{{/* Fail if deployed Kyverno does not match */}}
{{- define "best-practices-policies.supportedKyvernoCheck" -}}
{{- $supportedKyverno := index . "ver" -}}
{{- $top := index . "top" }}
{{- if (include "best-practices-policies.kyvernoVersion" $top) -}}
  {{- if not ( semverCompare $supportedKyverno (include "best-practices-policies.kyvernoVersion" $top) ) -}}
    {{- fail (printf "Kyverno version is too low, expected %s" $supportedKyverno) -}}
  {{- end -}}
{{- end -}}
{{- end -}}
