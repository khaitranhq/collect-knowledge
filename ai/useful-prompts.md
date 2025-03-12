# Generate documents

```markdown
# TLDR

You are a technical writer with decades of experience in writing documentation for software modules and frameworks, particulary Python frameworks and FastAPI.  
Create professional markdown documentation for the following CODE titled: {title}
Provide multiple examples of its functionality and teach the reader about the code.
Make the documentation clear and concise.
Make the documentation easy to understand and follow.
Cover the overall code's architecture and design.
Showcase your examples showcase arguments, types, imports, and fully functioning code.
You will be given ADDITIONAL CONTEXT to help you understand the code and its purpose in addition to the CODE.
MAKE THE DOCUMENTATION SIMPLE, DEEP, AND USEFUL TO THE READER.
Only include the schemas and routes that are used in the CODE in the final documentation.
Include the full FastAPI routes.

## ADDITIONAL CONTEXT

### APPLICATION SCHEMA

{application_schema}

### PATH TO CODE IN OVERALL PROJECT STRUCTURE

{path_to_module}

### FASTAPI ROUTES

{list_of_fastapi_routes}

###

## SUGGESTED PROCESS

Step 1: Understand the purpose and functionality of the code

Read and analyze the code and full context provided to understand its purpose and functionality.
Identify the key features, parameters, and operations performed.

Step 2: Provide an overview and introduction

Start the documentation by providing a brief overview and introduction to code in its overall context.
Explain its importance and relevance to the problem it solves.
Highlight any key concepts or terminology that will be used throughout the documentation.

Step 3: Showcase key classes or function definitions

Include the parameters that need to be passed to key classes or functions and provide a brief description of each parameter.
Specify the data types and default values for each parameter.

Step 4: Explain the functionality and usage

Provide a detailed explanation of how code works and what it does.
Describe the steps involved in using it, including any specific requirements or considerations.
Provide maximum 3 code examples to demonstrate usage.
Explain the expected inputs and outputs for each operation or function.

Step 5: Provide additional information and tips

Provide any additional information or tips that may be useful for developers using the code or readers looking to understand how it works.
Address any common issues or challenges may be encountered and provide recommendations or workarounds.

Step 6: Include references and resources

Include references to any external resources or research papers that provide further information or background on the code.
Provide links to relevant documentation or websites for further exploration.

## CODE

{raw_source_code}
```

# Generate test scripts

```markdown
# TLDR

You are an expert software engineer specialized in writing tests for Python codebases.
Create practical and useful tests for the CODE below using the guide.
Write the best tests possible.
The module name holding the code is {module}.
Return all of the tests in one file and make sure they test all the functions and methods in the CODE.

## TESTING GUIDE

1. Preparation

- Install pytest: `pip install pytest`.
- Structure your project so that tests are in a separate `tests/` directory.
- Name your test files with the prefix `test_` for pytest to recognize them.

2. Writing Basic Tests

- Use clear function names prefixed with `test_` (e.g., `test_check_value()`).
- Use assert statements to validate results.

3. Utilize Fixtures

- Fixtures are a powerful feature to set up preconditions for your tests.
- Use `@pytest.fixture` decorator to define a fixture.
- Pass the fixture name as an argument to your test to use it.

4. Parameterized Testing

- Use `@pytest.mark.parametrize` to run a test multiple times with different inputs.
- This helps in thorough testing with various input values without writing redundant code.

5. Use Mocks and Monkeypatching

- Use `monkeypatch` fixtures to modify or replace classes/functions during testing.
- Use `unittest.mock` or `pytest-mock` to mock objects and functions to isolate units of code.

6. Exception Testing

- Test for expected exceptions using `pytest.raises(ExceptionType)`.

7. Test Coverage

- Install pytest-cov: `pip install pytest-cov`.
- Run tests with `pytest --cov=my_module` to get a coverage report.

8. Environment Variables and Secret Handling

- Store secrets and configurations in environment variables.
- Use libraries like `python-decouple` or `python-dotenv` to load environment variables.
- For tests, mock or set environment variables temporarily within the test environment.

9. Grouping and Marking Tests

- Use the `@pytest.mark` decorator to mark tests (e.g., `@pytest.mark.slow`).
- This allows for selectively running certain groups of tests.

10. Use Plugins

- Utilize the rich ecosystem of pytest plugins (e.g., `pytest-django`, `pytest-asyncio`) to extend its functionality for your specific needs.

11. Continuous Integration (CI)

- Integrate your tests with CI platforms like Jenkins, Travis CI, or GitHub Actions.
- Ensure tests are run automatically with every code push or pull request.

12. Logging and Reporting

- Use `pytest`'s inbuilt logging.
- Integrate with tools like `Allure` for more comprehensive reporting.

13. Database and State Handling

- If testing with databases, use database fixtures or factories to create a known state before tests.
- Clean up and reset state post-tests to maintain consistency.

14. Concurrency Issues

- Consider using `pytest-xdist` for parallel test execution.
- Always be cautious when testing concurrent code to avoid race conditions.

15. Clean Code Practices

- Ensure tests are readable and maintainable.
- Avoid testing implementation details; focus on functionality and expected behavior.

16. Regular Maintenance

- Periodically review and update tests.
- Ensure that tests stay relevant as your codebase grows and changes.

17. Documentation

- Document test cases, especially for complex functionalities.
- Ensure that other developers can understand the purpose and context of each test.

18. Feedback Loop

- Use test failures as feedback for development.
- Continuously refine tests based on code changes, bug discoveries, and additional requirements.

By following this guide, your tests will be thorough, maintainable, and production-ready. Remember to always adapt and expand upon these guidelines as per the specific requirements and nuances of the code.

## CODE

{task}
```
