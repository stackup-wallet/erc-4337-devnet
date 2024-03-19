# ERC-4337 Devnet

A simple Docker setup to deploy ERC-4337 infrastructure on your local dev environment.

> **🚀 Need access to Smart Account infrastructure for your production environment? Check out [stackup.sh](https://www.stackup.sh/)!**

## Usage

The following command will deploy a local devnet with all the required ERC-4337 infrastructure components ready to go.

```bash
docker-compose up
```

Your dev env will be ready once you see the following log. This signals that the relevant contracts have been deployed to the devnet and all infra components are up and running.

```
erc-4337-devnet-deploy-v0.6.0-1 exited with code 0
```

**You can point you local applications to `http://localhost:8545` for access to all node and bundler RPC methods.**

## Useful commands

Fund any address on the devnet:

```bash
# ADDRESS and ETH can be set to any value.
make fund-address ADDRESS=0x... ETH=1
```

## Components

The ERC-4337 devnet is composed of several pieces:

- `node`: go-ethereum running in dev mode. It runs the [ERC-4337 Execution Client](https://github.com/stackup-wallet/erc-4337-execution-clients) build to leverage native bundler tracers.
- `bundler`: stackup-bundler that depends on `node` for the underlying ethereum client.
- `proxy`: [OpenResty](https://openresty.org/en/) server used to proxy JSON-RPC methods to the `node` or `bundler`.
- `fund-bundler`: A one off command to fund the bundler EOA on startup.
- `deploy-v0.6`: A one off command to deploy `v0.6` ERC-4337 contracts.
