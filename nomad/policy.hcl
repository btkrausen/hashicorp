namespace "default" {
  capabilities = ["submit-job", "read-logs", "alloc-exec", "scale-job"]
}

node {
  policy = "write"
}

plugin {
  policy = "list"
}

namespace "web-app" {
  capabilities = ["submit-job", "read-logs", "alloc-exec", "scale-job"]
}
