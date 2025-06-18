# The Cat API - Robot Framework Test Automation

This project contains an automated API test suite for The Cat API, built using Robot Framework and the `robotframework-requests` library.

## Features

- Structured and scalable framework design.
- Clear separation of test cases, keywords, and configuration.
- Positive and negative test scenarios.
- JSON Schema validation for API responses.
- Reusable keywords for common API interactions.
- Detailed logging and reporting via Robot Framework's default output.

## Covered Endpoints

The suite currently covers the following API endpoints:
- `GET /breeds`
- `GET /images/search`
- `POST /votes`
- `GET /votes`
- `DELETE /votes/{vote_id}` (for test cleanup)

---

## Prerequisites

- Python 3.11+
- pip (Python package installer)

---

## Setup Instructions

1.  **Clone the repository:**
    Organize the following files into the directory structure described in the "Project Structure" section below.

2.  **Install dependencies:**
    It is highly recommended to use a virtual environment.
    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows, use `venv\Scripts\activate`
    ```
    Install the required Python packages from the `requirements.txt` file:
    ```bash
    pip install -r requirements.txt
    ```

3.  **Configure API Key:**
    The tests require a valid API key from [TheCatAPI](https://thecatapi.com/signup) for authenticated endpoints like `/votes`.

    The framework is pre-configured to use the key provided in the prompt: `DEMO-API-KEY `.

    This key is set in the `configuration/api_suite_variables.robot` file.

    ```
    ${API_KEY}     DEMO-API-KEY 
    **Note:** The API key specified in the prompt (`ylX4blBYT9FaoVd6OhvR`) appears to be invalid or a placeholder. The `/votes` tests will fail with a `401 Unauthorized` error unless you sign up for a free, valid key and update this variable.

---

## Running the Tests

You can run the entire test suite or specific parts using the `robot` command from the project's root directory.

1.  **Run all tests:**
    ```bash
    robot tests/
    ```

2.  **Run a specific test file:**
    ```bash
    robot tests/votes.robot
    ```

3.  **Run tests by tag:**
    You can run tests with specific tags (e.g., `smoke`, `negative`, `schema`).
    ```bash
    # Run only smoke tests
    robot -d results --include smoke tests/

    # Run only tests for the 'votes' endpoint
    robot -d results --include votes tests/
    ```
4.  **Run tests from Github Actions:**
    You can run tests by navigating to Github Actions "EasyPay Cat API Assignment" workflow and clicking the Run "Workflow" button 

---

## Project Structure

├── README.md # This file

├── requirements.txt # Python dependencies

├── resources/ # Reusable components

│ ├── api_keywords.robot # Custom keywords for API interaction

│ ├── variables.py # Global variables (URL, API Key)

│ └── schemas/ # JSON schemas for response validation

│ ├── breeds_schema.json

│ ├── images_search_schema.json

│ └── votes_schema.json

├── tests/ # Test suite files

│ └── breeds.robot

│ └── images.robot

│ └── votes.robot