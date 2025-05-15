
# 💼 Freelance Reputation System Smart Contract

A Solidity-based decentralized reputation management system designed for freelancing platforms. This contract enables clients to review freelancers based on completed work, and includes moderation tools for admins.

---

## 🔐 Features

- ✅ **User Registration** (Freelancers & Clients)
- 🛠️ **Work Confirmation** (Admins only)
- ⭐ **Review & Rating System**
- 🚩 **Review Flagging** (Moderation)
- 📊 **Reputation Scoring & Average Rating**
- 👑 **Admin Management** (Owner only)

---

## 🧱 Contract Structure

### ✅ User Roles

- **Owner**: Contract deployer. Can assign or remove admins.
- **Admins**: Can confirm work relationships and flag reviews.
- **Clients**: Can submit reviews.
- **Freelancers**: Can receive reviews.

### 🗂 Data Structures

- `User`: Contains name, role, and registration status.
- `Review`: Contains rating, comment, timestamp, and moderation flag.

---

## 📘 Function Overview

### 🔹 Public Functions

| Function | Description |
|---------|-------------|
| `registerUser(string _name, bool _isFreelancer)` | Register as client or freelancer. |
| `submitReview(address _freelancer, uint8 _rating, string _comment)` | Submit a review for a freelancer. |
| `getReviewCount(address _freelancer)` | Returns total number of reviews for a freelancer. |
| `getReview(address _freelancer, uint256 _index)` | Returns detailed info of a review. |
| `getAverageReputation(address _freelancer)` | Returns average rating of a freelancer. |

### 🔹 Admin-Only Functions

| Function | Description |
|---------|-------------|
| `confirmWork(address _client, address _freelancer)` | Confirms that a freelancer worked with a client. |
| `flagReview(address _freelancer, uint256 _reviewIndex)` | Flags a review as inappropriate. |

### 🔹 Owner-Only Functions

| Function | Description |
|---------|-------------|
| `setAdmin(address _admin, bool _enabled)` | Adds or removes admin access. |

---

## 🧪 Example Usage

1. **Register as a Freelancer or Client**
   ```solidity
   registerUser("Alice", true);  // Freelancer
   registerUser("Bob", false);   // Client
   ```

2. **Confirm Work (Admin Only)**
   ```solidity
   confirmWork(bobAddress, aliceAddress);
   ```

3. **Submit Review (Client)**
   ```solidity
   submitReview(aliceAddress, 5, "Excellent work!");
   ```

4. **Get Reviews and Ratings**
   ```solidity
   getReviewCount(aliceAddress);
   getReview(aliceAddress, 0);
   getAverageReputation(aliceAddress);
   ```

---

## 🚨 Access Control

| Action | Who Can Do It? |
|--------|----------------|
| Register | Any unregistered user |
| Confirm Work | Admins only |
| Submit Review | Registered clients |
| Flag Review | Admins only |
| Set Admin | Owner only |

---

## 🛡️ Security Considerations

- Only verified clients (confirmed by admins) can submit reviews.
- Only owner can assign or remove admin rights.
- Admins can moderate (flag) suspicious or fake reviews.

---

## 📜 License

MIT License. See [`LICENSE`](./LICENSE) for details.
