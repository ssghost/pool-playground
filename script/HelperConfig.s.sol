// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Script} from "forge-std/Script.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {PoolPlayground} from "../src/PoolPlayground.sol";

contract HelperConfig is Script {
    function test() public {} // Added to remove this whole contract from coverage report.

    address public uniswapV2FactoryAddress;
    address public uniswapV2RouterAddress;

    struct NetworkConfig {
        PoolPlayground.ContractAddress[] contractAddresses;
    }

    function getChainVariables() public {
        uint256 chainId = block.chainid;

        if (chainId == 1 || chainId == 31337) {
            // Mainnet (Used for forks only)
            uniswapV2RouterAddress = vm.envAddress("MAINNET_ADDRESS_UNISWAP_V2_ROUTER");
            uniswapV2FactoryAddress = vm.envAddress("MAINNET_ADDRESS_UNISWAP_V2_FACTORY");
        } else if (chainId == 11155111 || chainId == 31338) {
            // Sepolia
            uniswapV2RouterAddress = vm.envAddress("SEPOLIA_ADDRESS_UNISWAP_V2_ROUTER");
            uniswapV2FactoryAddress = vm.envAddress("SEPOLIA_ADDRESS_UNISWAP_V2_FACTORY");
        } else if (chainId == 84532 || chainId == 31339) {
            // Base Sepolia
            uniswapV2RouterAddress = vm.envAddress("BASE_SEPOLIA_ADDRESS_UNISWAP_V2_ROUTER");
            uniswapV2FactoryAddress = vm.envAddress("BASE_SEPOLIA_ADDRESS_UNISWAP_V2_FACTORY");
        } else {
            revert(string(abi.encodePacked("Chain not supported: ", Strings.toString(block.chainid))));
        }
    }

    function getActiveNetworkConfig() public returns (NetworkConfig memory) {
        NetworkConfig memory activeNetworkConfig;

        getChainVariables();

        // Contract addresses
        PoolPlayground.ContractAddress[] memory contractAddresses = new PoolPlayground.ContractAddress[](2);
        contractAddresses[0] = PoolPlayground.ContractAddress("uniswapV2Router", uniswapV2RouterAddress);
        contractAddresses[1] = PoolPlayground.ContractAddress("uniswapV2Factory", uniswapV2FactoryAddress);

        activeNetworkConfig = NetworkConfig({contractAddresses: contractAddresses});

        return activeNetworkConfig;
    }
}