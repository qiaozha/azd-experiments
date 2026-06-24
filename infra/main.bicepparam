using './main.bicep'

param location = 'westus2'
param resourceGroupName = 'azure-sdk-qa-bot'

// Logic App Parameters
param teamsGroupId = '3e17dcb0-4257-4a30-b843-77f47f1d4121'

param teamsChannelIds = [
  '19:de3fce22c2994be18cac50502c55f717@thread.skype'
  '19:906c1efbbec54dc8949ac736633e6bdf@thread.skype'
  '19:b97d98e6d22c41e0970a1150b484d935@thread.skype'
  '19:0351f5f9404446e4b4fd4eaf2c27448d@thread.skype'
  '19:f6d52ac6465c40ea80dc86b8be3825aa@thread.skype'
  '19:084875bb626242ed95f3ac8dddfaa12a@thread.skype'
  '19:5e673e41085f4a7eaaf20823b85b2b53@thread.skype'
]

// Entra app registration
param serverAudience = '899da762-d510-48f2-911a-db9ea0cc41fd'

// Function App container image (registry/repository:tag)
param functionImageRepository = 'azure-sdk-qa-bot-function:latest'

// Backend container image (repository:tag; registry from shared Container Registry)
param ragBasedBackendImageRepository = 'azure-sdk-qa-bot-backend:latest'

// Agent server slot container image (repository:tag; registry from shared Container Registry)
param agentBasedImageRepository = 'azure-sdk-qa-bot-agent-server:latest'
