# 📜 Collaborative Curation Smart Contract

This Solidity smart contract implements a decentralized system where users can submit content items and the community can vote to either accept or reject them. It is designed to promote collaboration, fair voting, and content curation based on reputation and voting thresholds.

---

## 🚀 Features

- ✅ **Item Submission**: Users with sufficient reputation can submit content.
- 👍 **Voting Mechanism**: Users can upvote or downvote submitted items.
- 🏆 **Acceptance Criteria**: Items are marked as accepted based on a customizable upvote/downvote ratio and minimum votes.
- 🌟 **Reputation System**: Owner can award reputation points to users to enable participation.
- 🔒 **Owner Privileges**: The contract owner can set parameters like:
  - Submission reputation threshold
  - Vote acceptance ratio
  - Minimum votes needed for evaluation

---

## 🛠️ Smart Contract Details

- **Solidity Version:** `^0.8.0`
- **EVM Version Recommendation:** `london` or newer (set via Hardhat/Truffle config)
- **License:** MIT

---

## 🔧 Configuration Parameters

| Parameter | Description | Default |
|----------|-------------|---------|
| `submissionThreshold` | Minimum reputation to submit an item | `0` |
| `acceptanceRatio` | % of upvotes required to accept | `60` |
| `minVotesToEvaluate` | Minimum number of total votes to evaluate an item | `5` |

---

## 🧱 Data Structures

### `Item`
```solidity
struct Item {
    string content;
    uint upvotes;
    uint downvotes;
    mapping(address => bool) hasVoted;
    address submitter;
    uint submissionTime;
    bool isAccepted;
}
```

Contract Detail: 0x425be31f5044f53fdc85baabd2d5a0b32c1af6deb98a89cd4e18b9f5a134b624

![Screenshot (68)](https://github.com/user-attachments/assets/0925a64f-4fa9-430b-b7e7-81c1d08ae52e)
