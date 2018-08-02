# Regex to match only Gatsby-approved domains.
linkRegex="^https:\/\/([a-zA-Z0-9]+.)?(gatsbyjs.(org|com)|github.com\/gatsbyjs)[a-zA-Z0-9\/_%&=+?#-]*$"

# Regex to only allow lowercase letters, numbers, and hyphens. 
shortlinkRegex="^[a-z0-9-]+$"

# Regex to match a successful HTTP code
status200Regex=".*(\"status\":\"active\").*"

# Shorten a link for use with the https://gatsby.app domain.
#
# NOTE: You MUST set REBRANDLY_API_KEY in your bash profile prior to running this.
#
# This _must_ be a Gatsby domain:
# - https://gatsbyjs.com
# - https://gatsbyjs.org
# - https://github.com/gatsbyjs
gatsbylink() {
  domain="gatsby.app"
  destination=$1
  shortlink=$2

  # Ensure that an API key is set.
  if [ -z ${REBRANDLY_API_KEY+x} ]
  then
    echo "No API key is set!"
    echo "See the company password vault to get our API key."
    return
  fi

  # Ensure that a valid Gatsby destination link was supplied.
  if [[ ! $destination =~ $linkRegex ]]
  then
    echo "$destination is not a valid Gatsby link."
    echo ""
    echo "Valid Gatsby link domains can start with one of these domains:"
    echo "  - https://*.gatsbyjs.org"
    echo "  - https://*.gatsbyjs.com"
    echo "  - https://www.github.com/gatsbyjs"
    echo ""
    echo "NOTES:"
    echo "  - All subdomains for gatsbyjs domains are supported"
    echo "  - Only secure links are supported (i.e. they start with https://)"
    echo "  - GitHub links work with and without www"
    echo ""
    echo "If you think this is incorrect, yell at Jason."
    echo ""
    echo "Usage:"
    echo "    gatsbylink <url> <shortlink>"
    echo "    # => creates 'https://$domain/<shortlink>'"
    return 1
  fi

  # Check if a valid shortlink was supplied.
  if [[ ! $shortlink =~ $shortlinkRegex ]]
  then
    echo "Error: no valid shortlink supplied."
    echo "Only lowercase letters, numbers, and hyphens (-) are allowed in shortlinks."
    echo ""
    echo "Usage:"
    echo "    gatsbylink <url> <shortlink>"
    echo "    # => creates 'https://$domain/<shortlink>'"
    return 1
  fi

  # Create the required headers for creating shortlinks via API calls.
  headers="-H 'Content-Type: application/json'"
  headers="$headers -H 'apikey: $REBRANDLY_API_KEY'"
  headers="$headers -d '{ \"destination\": \"$destination\", \"domain\": { \"fullName\": \"$domain\" }, \"slashtag\": \"$shortlink\" }'"

  # Send the response to Rebrandly and check for success.
  response=$(eval "curl -i https://api.rebrandly.com/v1/links $headers 2>&1")

  # If there was an error, dump the full response in the console.
  if [[ ! $response =~ $status200Regex ]]
  then
    echo "Error: something went wrong. The full response from Rebrandly was:"
    echo $response
    return
  fi

  # If we get here, we’ve got a valid shortlink!
  echo "Your shortlink is ready: https://$domain/$shortlink"
}
