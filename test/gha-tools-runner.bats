#!/usr/bin/env bats

setup() {
  if [[ -z "${TEST_CONTAINER}" ]]; then
    echo "ERROR: TEST_CONTAINER environment variable is not set"
    echo "Example:"
    echo "  TEST_CONTAINER=my-container bats tests.bats"
    exit 1
  fi
}

@test "node installed" {
  run bash -c "docker exec ${TEST_CONTAINER} node --help"
  [[ "${output}" =~ "Usage:" ]]
}

@test "npm installed" {
  run bash -c "docker exec ${TEST_CONTAINER} npm --help"
  [[ "${output}" =~ "Usage:" ]]
}

@test "hadolint installed" {
  run bash -c "docker exec ${TEST_CONTAINER} hadolint --help"
  [[ "${output}" =~ "Usage:" ]]
}

@test "trivy installed" {
  run bash -c "docker exec ${TEST_CONTAINER} trivy --help"
  [[ "${output}" =~ "Usage:" ]]
}

@test "syft installed" {
  run bash -c "docker exec ${TEST_CONTAINER} syft --help"
  [[ "${output}" =~ "Usage:" ]]
}

@test "oras installed" {
  run bash -c "docker exec ${TEST_CONTAINER} oras --help"
  [[ "${output}" =~ "Usage:" ]]
}

@test "cosign installed" {
  run bash -c "docker exec ${TEST_CONTAINER} cosign --help"
  [[ "${output}" =~ "Usage:" ]]
}

@test "grype installed" {
  run bash -c "docker exec ${TEST_CONTAINER} grype --help"
  [[ "${output}" =~ "Usage:" ]]
}
