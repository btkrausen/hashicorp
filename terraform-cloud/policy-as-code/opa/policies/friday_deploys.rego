package terraform.policies.friday_deploys

deny[msg] {
  time.weekday(time.now_ns()) == "Monday"

  msg := "No deployments allowed on Mondays"
}
