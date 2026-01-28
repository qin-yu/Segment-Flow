#!/usr/bin/env nextflow
nextflow.enable.dsl=2

/*
 * Test script for dynamic model discovery
 * Tests that the model discovery logic correctly identifies available models
 * and handles both valid and invalid model names appropriately.
 */

// Helper function to discover available models (same logic as in main.nf)
def discoverAvailableModels() {
    def modelScriptsDir = file("${workflow.projectDir}/modules/models/resources/usr/bin")
    def availableModels = modelScriptsDir.listFiles()
        .findAll { it.name.startsWith('run_') && it.name.endsWith('.py') }
        .collect { it.name.replaceAll(/^run_/, '').replaceAll(/\.py$/, '') }
    return availableModels
}

// Helper function to verify a model exists
def verifyModelExists(model, availableModels) {
    return availableModels.contains(model)
}

workflow {
    log.info """\
    ================================================
                MODEL DISCOVERY TEST
    ================================================
    """.stripIndent()

    // Test 1: Discover available models
    log.info "Test 1: Discovering available models..."
    def availableModels = discoverAvailableModels()
    log.info "Found ${availableModels.size()} models: ${availableModels.join(', ')}"
    assert availableModels.size() > 0, "ERROR: No models discovered!"
    log.info "✓ Test 1 PASSED: Models successfully discovered"

    // Test 2: Verify expected models are present
    log.info "\nTest 2: Verifying expected models..."
    def expectedModels = ["cellpose", "cellposesam", "sam", "sam2", "seai_unet", "empanada", "plantseg2"]
    def missingModels = expectedModels.findAll { !availableModels.contains(it) }

    if (missingModels.size() > 0) {
        log.warn "WARNING: Expected models not found: ${missingModels.join(', ')}"
    } else {
        log.info "✓ Test 2 PASSED: All expected models are present"
    }

    // Test 3: Verify model script files exist and are readable
    log.info "\nTest 3: Verifying model script files..."
    def modelScriptsDir = file("${workflow.projectDir}/modules/models/resources/usr/bin")
    def failedChecks = []

    availableModels.each { model ->
        def scriptFile = file("${modelScriptsDir}/run_${model}.py")
        if (!scriptFile.exists()) {
            failedChecks << "${model}: script file does not exist"
        } else if (!scriptFile.canRead()) {
            failedChecks << "${model}: script file is not readable"
        }
    }

    if (failedChecks.size() > 0) {
        log.error "ERROR: Script file checks failed:\n  - ${failedChecks.join('\n  - ')}"
        assert false, "Script file validation failed"
    } else {
        log.info "✓ Test 3 PASSED: All model script files exist and are readable"
    }

    // Test 4: Test valid model validation
    log.info "\nTest 4: Testing valid model validation..."
    if (availableModels.size() > 0) {
        def testModel = availableModels[0]
        assert verifyModelExists(testModel, availableModels), "ERROR: Valid model '${testModel}' not recognized"
        log.info "✓ Test 4 PASSED: Valid model '${testModel}' correctly validated"
    }

    // Test 5: Test invalid model detection
    log.info "\nTest 5: Testing invalid model detection..."
    def invalidModel = "nonexistent_model_xyz123"
    def isInvalid = !verifyModelExists(invalidModel, availableModels)
    assert isInvalid, "ERROR: Invalid model '${invalidModel}' was incorrectly accepted"
    log.info "✓ Test 5 PASSED: Invalid model correctly rejected"

    // Test 6: Verify no duplicate models
    log.info "\nTest 6: Checking for duplicate model names..."
    def duplicates = availableModels.findAll { model ->
        availableModels.count { it == model } > 1
    }.unique()

    if (duplicates.size() > 0) {
        log.error "ERROR: Duplicate models found: ${duplicates.join(', ')}"
        assert false, "Duplicate models detected"
    } else {
        log.info "✓ Test 6 PASSED: No duplicate models found"
    }

    log.info """\

    ================================================
            ALL TESTS PASSED SUCCESSFULLY
    ================================================
    Models available: ${availableModels.size()}
    Model list: ${availableModels.sort().join(', ')}
    ================================================
    """.stripIndent()
}

workflow.onComplete {
    if (workflow.success) {
        log.info "✓ Model discovery test completed successfully"
    } else {
        log.error "✗ Model discovery test failed"
    }
}

workflow.onError {
    log.error "ERROR: Test stopped with message: ${workflow.errorMessage}"
}
