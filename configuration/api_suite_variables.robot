*** Variables ***
# The base URL for all API endpoints.            
${BASE_URL}    https://api.thecatapi.com/v1
${API_KEY}     DEMO-API-KEY    #ylX4blBYT9FaoVd6OhvR *This key did not work

# An intentionally invalid API key for negative testing.
${BAD_API_KEY}  this-is-a-bad-key

# Default headers for API requests.
&{HEADERS}  Content-Type=application/json
&{AUTH_HEADERS}  Content-Type=application/json  x-api-key=${API_KEY}

# Shared runtime variables.
${IMAGE_ID_TO_VOTE}    # Will be set in setup
${CREATED_VOTE_ID}     # Will be set during test