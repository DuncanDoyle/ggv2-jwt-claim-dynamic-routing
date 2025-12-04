# Gloo Gateway V2 - Dynamic Routing based on JWT Claims

## Installation

Export your Gloo Gateway license key:

```
export GLOO_GATEWAY_LICENSE_KEY={your_gg_license_key}
```

Install Gloo Gateway:
```
cd install
./install-ggv2-with-helm.sh
```

> NOTE
> The Gloo Gateway version that will be installed is set in a variable at the top of the `install/install-ggv2-with-helm.sh` installation script.

## Setup the environment

Run the `install/setup.sh` script to setup the environment:

- Create the required namespaces
- Deploy the Gateway
- Deploy the ExtAuth GatewayExtension
- Deploy the HTTPBin application
- Deploy the Reference Grants
- Deploy the HTTPRoute (K8S Gateway API)
- Deploy the JWT GlooTrafficPolicy

```
./setup.sh
```

## Access the HTTPBin application

The `./routes/api-example-com-httproute.yaml` `HTTPRoute` contains 3 routing rules:
- Default routing rule that routes to the HTTPBin application. The route adds a "route-name: default" header to the request.
- Route-A routing rule. This rule matches on the "route: a" header and will add a "route-name: route-a" header to the request.
- Route-B routing rule. This rule matches on the "route: b" header and will add a "route-name: route-b" header to the request.

Furthermore, the `./policies/gloojwt-glootrafficpolicy.yaml` will process the JWT, and allow or deny request based on the JWT validity, and will add the `route` claim to the `route` header (using the `claimsToHeaders` feature).

There are 3 curl request scripts:
- curl-request-default-route.sh: This script will use a JTW to access the request which does not contain a "route" claim.
- curl-request-route-a.sh: This script will use a JTW to access the request which contains a "route" claim with value "a".
- curl-request-route-b.sh: This script will use a JTW to access the request which contains a "route" claim with value "b".


When the JWT policy extracts the claim and puts it in header, it will automatically clear the route cache, and will re-apply the routing rules. This will cause the correct routing rule to be selected depending on the "route" header that has beed added by the JWT policy.

Hence:
- curl-request-default-route.sh:  will route to the default route. The request that is send to HTTPBin will contain the request header "route-name:default", which can be seen in the HTTPBin response.
- curl-request-route-a.sh:  will route to route-a. The request that is send to HTTPBin will contain the request header "route-name: route-a", which can be seen in the HTTPBin response.
- curl-request-route-b.sh:  will route to route-b. The request that is send to HTTPBin will contain the request header "route-name: route-b", which can be seen in the HTTPBin response.