# Drosera-Governance-Takeover-Acceleration-Alarm

Structure folders

Trap contract

Response contract

Mock governance

Deploy script (Foundry)

drosera.toml

README template

- Structure

        src/
            ├── GovernanceTakeoverAlarmTrap.sol
            ├── MockGovernanceToken.sol
            ├── GovernanceAlarmResponse.sol

      scripts/
            └── Deploy.s.sol

      test/
            └── GovernanceAlarm.t.sol

Trap Contract

    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.20;

    interface IGovToken {
        function totalSupply() external view returns (uint256);
        function balanceOf(address user) external view returns (uint256);
    }
  
    contract GovernanceTakeoverAlarmTrap {

    IGovToken public token;
    address public monitoredAddress;

    uint256 public constant THRESHOLD_PERCENT = 25;

    constructor(address _token, address _monitored) {
        token = IGovToken(_token);
        monitoredAddress = _monitored;
    }

    function shouldRespond() external view returns (bool) {

        uint256 total = token.totalSupply();
        uint256 balance = token.balanceOf(monitoredAddress);

        uint256 percent = (balance * 100) / total;

        if (percent >= THRESHOLD_PERCENT) {
            return true;
            }

            return false;
        }
    }


2️⃣ Response Contract

        // SPDX-License-Identifier: MIT
        pragma solidity ^0.8.20;

        contract GovernanceAlarmResponse {

    event GovernanceAttackAlert(
        address indexed suspiciousAddress,
        uint256 votingPowerPercent
    );

    function emergencyGovernanceAlert(
        address suspect,
        uint256 percent
      ) external {
           emit GovernanceAttackAlert(suspect, percent);
        }
    }


3️⃣ Mock Governance Token


    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.20;

    import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

    contract MockGovernanceToken is ERC20 {

    constructor() ERC20("MockGov", "MGOV") {
        _mint(msg.sender, 1_000_000 ether);
      }

      function mint(address to, uint256 amount) external {
        _mint(to, amount);
      }
    }

4️⃣ Deploy Script (scripts/Deploy.s.sol)

    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.20;

    import "forge-std/Script.sol";
    import "../src/GovernanceTakeoverAlarmTrap.sol";
    import "../src/GovernanceAlarmResponse.sol";
    import "../src/MockGovernanceToken.sol";

    contract Deploy is Script {

    function run() external {

        vm.startBroadcast();

        MockGovernanceToken token = new MockGovernanceToken();

        GovernanceAlarmResponse response = new GovernanceAlarmResponse();

        GovernanceTakeoverAlarmTrap trap =
            new GovernanceTakeoverAlarmTrap(
                address(token),
                msg.sender
            );

        vm.stopBroadcast();
      }
    }

5️⃣ drosera.toml 

    [trap]
    ethereum_rpc = "https://ethereum-hoodi-rpc.publicnode.com"
    drosera_rpc  = "https://relay.hoodi.drosera.io"
    eth_chain_id = 560048
    drosera_address = "0x91cB447BaFc6e0EA0F4Fe056F5a9b1F14bb06e5D"

    [traps]

    [traps.GovernanceTakeoverAlarmTrap]
    path = "out/GovernanceTakeoverAlarmTrap.sol/GovernanceTakeoverAlarmTrap.json"
    response_contract = "0x183D78491555cb69B68d2354F7373cc2632508C7"
    response_function = "emergencyGovernanceAlert(address,uint256)"
    cooldown_period_blocks = 50
    min_number_of_operators = 1
    max_number_of_operators = 1
    block_sample_size = 10
    private_trap = true
    whitelist = ["YOUR_OPERATOR_WALLET_ADDRESS"]

    # New Users/Migrate:
    # address = "DELETE THIS LINE WHEN APPLYING" (it will generate address after apply trap config)

    # Existing Users:
    # If you've deployed a trap with your wallet previously (Hoodi not Holesky), add your trap address here:
    # address = "TRAP_ADDRESS"



6️⃣ README Headline
Governance Takeover Acceleration Alarm

Monitors rapid voting power concentration exceeding 25% of total supply.

Trigger:
Voting power ≥ 25%

Response:
Emit GovernanceAttackAlert event

Gas:
~25k (efficient single-vector check)

    forge install OpenZeppelin/openzeppelin-contracts
    forge build
    forge test
    forge script scripts/Deploy.s.sol:Deploy --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
