import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config();

const { ALCHEMY_API_HTTP_URL, PRIVATE_KEY } = process.env;

const config: HardhatUserConfig = {
    solidity: "0.8.17",
    defaultNetwork: "goerli",
    networks: {
        hardhat: {},
        goerli: {
            url: ALCHEMY_API_HTTP_URL,
            accounts: [`0x${PRIVATE_KEY}`],
        },
    },
};

export default config;
