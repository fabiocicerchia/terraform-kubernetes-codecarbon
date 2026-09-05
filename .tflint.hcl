plugin "terraform" {
  enabled = true
  preset  = "all"
}

rule "terraform_required_version" { enabled = true }     # FC-TF-006
rule "terraform_required_providers" { enabled = true }   # FC-TF-006
rule "terraform_documented_variables" { enabled = true } # FC-TF-003
rule "terraform_documented_outputs" { enabled = true }   # FC-TF-005
rule "terraform_typed_variables" { enabled = true }      # FC-TF-003
rule "terraform_naming_convention" {                     # FC-TF-011
  enabled = true
  format  = "snake_case"
}
rule "terraform_unused_declarations" { enabled = true }
rule "terraform_module_pinned_source" { enabled = true }  # FC-TF-006
