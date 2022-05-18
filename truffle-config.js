const path = require("path");

module.exports = {
	contracts_build_directory: path.join(__dirname, "client/src/contracts"),
	networks: {
	},
	mocha: {
	},
	compilers: {
		solc: {
			version: "^0.8.0",    // Fetch exact version from solc-bin (default: truffle's version)
		}
	}
}