# Sui dApp Starter Template

This dApp was created using `@mysten/create-dapp` that sets up a basic React
Client dApp using the following tools:

- [React](https://react.dev/) as the UI framework
- [TypeScript](https://www.typescriptlang.org/) for type checking
- [Vite](https://vitejs.dev/) for build tooling
- [Radix UI](https://www.radix-ui.com/) for pre-built UI components
- [ESLint](https://eslint.org/)
- [`@mysten/dapp-kit`](https://sdk.mystenlabs.com/dapp-kit) for connecting to
  wallets and loading data
- [npm](https://www.npmjs.com/) for package management

## Starting your dApp

> [!IMPORTANT]
> My dapp runs with node version v18.20.4, but when I run cmd "npm create @mystem/dapp" and run cmd "npm install" I get an error installing eslint so I update package.json with the version Other eslint is below

```sh
  "eslint": "^8.56.0",
  "@typescript-eslint/parser": "^7.18.0",
  "@typescript-eslint/eslint-plugin": "^7.18.0", 
```

After that,  you can run to install all dependencies:

```bash
npm install
```

To start your dApp in development mode run

```bash
npm run dev
```

## Building

To build your app for deployment you can run

```bash
npm run build
```

## Implement the transfer component
1. Install mui meterial:

You can learn about MUI at [MUI Installation](https://mui.com/material-ui/getting-started/installation/)

```sh
npm install @mui/material @emotion/react @emotion/styled @mui/icons-material
```

2. You need to create two files [Transfer](src/Transfer.tsx) and [SuiDialog](src/SuiDialog.tsx) to handle new transaction

3. Run project and testing
Demo 

[![SUI DAPP](image.png)](https://youtu.be/m9TALQXB7WQ)


# How to test this dapp
## Step 1: Run your dapp
``` sh
npm run dev
``` 
## Step 2: Connect to your sui wallet
i will demo with the testnet network 

## Step 3: Click button to Create new transaction

## Step 4: type amount you want to send and the address recipient

- Firstly, get sui cli address:
```sh
sui client active-addresses
```
> [!NOTE]
> 1 SUI = 10^9 Gas so I will send 0.2 SUI

- Secondly, check sui cli wellet balance before doing this transaction
```sh
sui client balance
```
## Step 4: Start  transaction

> [!INFO]
> you can check this transaction by using [suiscan.xyz/tesnet](https://suiscan.xyz/testnet/tx)

Check your sui cli client balance again and verify your transaction

# OK SO THANK YOU FOR WATCHING ME ^^ <3>