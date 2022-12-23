{{/* vim: set filetype=mustache: */}}
{{/* Expand the name of the chart. */}}
{{- define "pod-security-standard-policies.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Create chart name and version as used by the chart label. */}}
{{- define "pod-security-standard-policies.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Helm required labels */}}
{{- define "pod-security-standard-policies.labels" -}}
app.kubernetes.io/component: kyverno
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: {{ template "pod-security-standard-policies.name" . }}
app.kubernetes.io/part-of: {{ template "pod-security-standard-policies.name" . }}
app.kubernetes.io/version: "{{ .Chart.Version }}"
helm.sh/chart: {{ template "pod-security-standard-policies.chart" . }}
{{- if .Values.customLabels }}
{{ toYaml .Values.customLabels }}
{{- end }}
{{- end -}}

{{/* Set if a baseline policy is managed */}}
{{- define "pod-security-standard-policies.podSecurityBaseline" -}}
{{- if or (eq .Values.podSecurityStandard "baseline") (eq .Values.podSecurityStandard "restricted") }}
{{- true }}
{{- else if and (eq .Values.podSecurityStandard "custom") (has .name .Values.podSecurityPolicies) }}
{{- true }}
{{- else -}}
{{- false }}
{{- end -}}
{{- end -}}

{{/* Set if a restricted policy is managed */}}
{{- define "pod-security-standard-policies.podSecurityRestricted" -}}
{{- if eq .Values.podSecurityStandard "restricted" }}
{{- true }}
{{- else if and (eq .Values.podSecurityStandard "custom") (has .name .Values.podSecurityPolicies) }}
{{- true }}
{{- else if has .name .Values.includeRestrictedPolicies }}
{{- true }}
{{- else -}}
{{- false }}
{{- end -}}
{{- end -}}

{{/* Set if a other policies are managed */}}
{{- define "pod-security-standard-policies.podSecurityOther" -}}
{{- if has .name .Values.includeOtherPolicies }}
{{- true }}
{{- else -}}
{{- false }}
{{- end -}}
{{- end -}}

{{/* Get deployed Kyverno version from Kubernetes */}}
{{- define "pod-security-standard-policies.kyvernoVersion" -}}
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
{{- define "pod-security-standard-policies.supportedKyvernoCheck" -}}
{{- $supportedKyverno := index . "ver" -}}
{{- $top := index . "top" }}
{{- if (include "pod-security-standard-policies.kyvernoVersion" $top) -}}
  {{- if not ( semverCompare $supportedKyverno (include "pod-security-standard-policies.kyvernoVersion" $top) ) -}}
    {{- fail (printf "Kyverno version is too low, expected %s" $supportedKyverno) -}}
  {{- end -}}
{{- end -}}
{{- end -}}
