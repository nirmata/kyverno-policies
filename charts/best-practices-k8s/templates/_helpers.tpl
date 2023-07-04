{{/*
Validation failure action for policy or default validation failure action
*/}}

{{- define "vfa-for-pol" -}}

{{- with index .Values "validationFailureActionByPolicy" .polname }}
{{- toYaml . }}
{{- else }}
{{- .Values.validationFailureAction }}
{{- end }}

{{- end}}


{{/*
Background scan for policy or default background value
*/}}
{{- define "bgscan-for-pol" -}}
{{- $flagStr := lower (toString (index .Values "backgroundByPolicy" .polname)) }}

{{- if eq "false" $flagStr }}
{{- false }}
{{- else if eq "true" $flagStr }}
{{- true }}
{{- else }}
{{- .Values.background }}
{{- end }}

{{- end}}
