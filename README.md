# 🪙 SimpleWallet Smart Contract

A secure smart wallet built in Solidity, allowing an owner to manage funds and set withdrawal allowances for other addresses. Based on OpenZeppelin's `Ownable`, this contract enforces owner-based permission controls and prevents contract renunciation.

---

## 🚀 Features

- Owner-restricted control using OpenZeppelin's `Ownable`
- Fine-grained **allowance system** for limited access withdrawals
- Event logging for transparency
- Prevents renouncing contract ownership (secure access lock-in)
- Accepts direct Ether transfers via `receive()` function

---

## 🛠️ How It Works

### 🔐 Ownership

The `SimpleWallet` inherits from `Allowance`, which itself inherits from OpenZeppelin’s `Ownable`. This provides a secure way to assign a contract owner and restrict sensitive operations.

The `renounceOwnership()` function is **intentionally disabled** to prevent loss of control:

```solidity
function renounceOwnership() public override(Ownable) onlyOwner {
    revert("Cant renounce ownership here");
}
```


### 💰 Deposits
You can send Ether directly to the contract using the Remix GUI or via other wallets.

```solidity
receive() external payable
```

This logs an event:

```solidity
event MoneyRecived(address indexed _from, uint _amount);
```



### 🧾 Allowance System
The owner can grant or update withdrawal limits to other addresses:
```solidity
function addAllowance(address _who, uint _amount) public onlyOwner
```

All changes are tracked via:

```solidity
event AllowanceChanged(address indexed _forWho, address indexed _fromWho, uint _oldAccount, uint _newAccount);
```
If a non-owner tries to withdraw money, their `allowance` is checked.

### 💸 Withdrawals
Only the owner or allowed users can call:
```solidity
function withdrawMoney(address payable _to, uint256 _amount) public ownerOrAlowed(_amount)
```

If the caller is not the owner, their allowance will be reduced accordingly.

Event emitted:
```solidity
event MoneySent(address _beneficiary, uint _amount);
```

---

### 🧪 How to Use (via Remix)
1. Open Remix.

2. Create `Allowance.sol` and `SimpleWallet.sol` files and paste in the respective code.

3. Compile both contracts.

4. Deploy `SimpleWallet` with the constructor argument (your wallet address).

5. Use the `receive()` functionality to deposit ETH.

6. Use `addAllowance()` as the owner to permit other accounts.

7. Connect with other accounts in Remix to test withdrawals.

8. Withdraw using `withdrawMoney()`.

---

### ⚠️ Security Notes
- Only the owner can update allowances.

- The contract cannot be renounced — preventing accidental lock-out.

- Underflow protection is enforced when reducing allowances.

- Avoid transferring contract ownership unless absolutely necessary.


# SimpleWallet-Smart-Contract
