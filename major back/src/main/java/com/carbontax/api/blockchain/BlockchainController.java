package com.carbontax.api.blockchain;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.web3j.protocol.core.methods.response.TransactionReceipt;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

/**
 * REST Controller for blockchain interactions
 */
@RestController
@RequestMapping("/api/blockchain")
@CrossOrigin(origins = "*")
public class BlockchainController {

    private static final Logger log = LoggerFactory.getLogger(BlockchainController.class);

    @Autowired
    private Web3Service web3Service;

    // ============ System Status ============

    @GetMapping("/status")
    public ResponseEntity<Map<String, Object>> getBlockchainStatus() {
        Map<String, Object> status = new HashMap<>();
        status.put("connected", web3Service.isConnected());
        status.put("contractAddress", web3Service.getContractAddress());
        
        if (web3Service.getCredentials() != null) {
            status.put("walletAddress", web3Service.getCredentials().getAddress());
        }
        
        return ResponseEntity.ok(status);
    }

    @GetMapping("/stats")
    public CompletableFuture<ResponseEntity<Map<String, Object>>> getSystemStats() {
        return web3Service.getSystemStats()
            .thenApply(ResponseEntity::ok)
            .exceptionally(ex -> {
                log.error("Error getting system stats", ex);
                return ResponseEntity.internalServerError().build();
            });
    }

    // ============ Account Management ============

    @GetMapping("/balance/{address}")
    public CompletableFuture<ResponseEntity<Map<String, Object>>> getBalance(@PathVariable String address) {
        return web3Service.getBalance(address)
            .thenCombine(
                web3Service.getTokenBalance(address),
                (ethBalance, tokenBalance) -> {
                    Map<String, Object> balances = new HashMap<>();
                    balances.put("ethBalance", ethBalance);
                    balances.put("tokenBalance", tokenBalance);
                    return ResponseEntity.ok(balances);
                }
            )
            .exceptionally(ex -> {
                log.error("Error getting balance for address: {}", address, ex);
                return ResponseEntity.internalServerError().build();
            });
    }

    // ============ Product Management ============

    @PostMapping("/products")
    public CompletableFuture<ResponseEntity<Map<String, Object>>> addProduct(
            @RequestBody ProductRequest request) {
        
        return web3Service.addProduct(request.getName(), request.getBasePrice(), request.getCarbonEmission())
            .thenApply(receipt -> {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("transactionHash", receipt.getTransactionHash());
                response.put("blockNumber", receipt.getBlockNumber());
                return ResponseEntity.ok(response);
            })
            .exceptionally(ex -> {
                log.error("Error adding product", ex);
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("error", ex.getMessage());
                return ResponseEntity.badRequest().body(response);
            });
    }

    @GetMapping("/products/{productId}")
    public CompletableFuture<ResponseEntity<Map<String, Object>>> getProduct(@PathVariable String productId) {
        return web3Service.getProduct(new BigInteger(productId))
            .thenApply(ResponseEntity::ok)
            .exceptionally(ex -> {
                log.error("Error getting product: {}", productId, ex);
                return ResponseEntity.notFound().build();
            });
    }

    @PostMapping("/products/{productId}/purchase")
    public CompletableFuture<ResponseEntity<Map<String, Object>>> purchaseProduct(
            @PathVariable String productId,
            @RequestBody PurchaseRequest request) {
        
        return web3Service.purchaseProduct(new BigInteger(productId), request.getTotalAmount())
            .thenApply(receipt -> {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("transactionHash", receipt.getTransactionHash());
                response.put("blockNumber", receipt.getBlockNumber());
                return ResponseEntity.ok(response);
            })
            .exceptionally(ex -> {
                log.error("Error purchasing product: {}", productId, ex);
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("error", ex.getMessage());
                return ResponseEntity.badRequest().body(response);
            });
    }

    // ============ Staking Functions ============

    @PostMapping("/stake")
    public CompletableFuture<ResponseEntity<Map<String, Object>>> stakeTokens(
            @RequestBody StakeRequest request) {
        
        return web3Service.stakeTokens(request.getAmount())
            .thenApply(receipt -> {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("transactionHash", receipt.getTransactionHash());
                response.put("message", "Tokens staked successfully");
                return ResponseEntity.ok(response);
            })
            .exceptionally(ex -> {
                log.error("Error staking tokens", ex);
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("error", ex.getMessage());
                return ResponseEntity.badRequest().body(response);
            });
    }

    @PostMapping("/unstake")
    public CompletableFuture<ResponseEntity<Map<String, Object>>> unstakeTokens() {
        return web3Service.unstakeTokens()
            .thenApply(receipt -> {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("transactionHash", receipt.getTransactionHash());
                response.put("message", "Tokens unstaked successfully");
                return ResponseEntity.ok(response);
            })
            .exceptionally(ex -> {
                log.error("Error unstaking tokens", ex);
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("error", ex.getMessage());
                return ResponseEntity.badRequest().body(response);
            });
    }

    @PostMapping("/claim-rewards")
    public CompletableFuture<ResponseEntity<Map<String, Object>>> claimRewards() {
        return web3Service.claimRewards()
            .thenApply(receipt -> {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("transactionHash", receipt.getTransactionHash());
                response.put("message", "Rewards claimed successfully");
                return ResponseEntity.ok(response);
            })
            .exceptionally(ex -> {
                log.error("Error claiming rewards", ex);
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("error", ex.getMessage());
                return ResponseEntity.badRequest().body(response);
            });
    }

    @GetMapping("/validators/{address}")
    public CompletableFuture<ResponseEntity<Map<String, Object>>> getValidatorInfo(@PathVariable String address) {
        return web3Service.getValidatorInfo(address)
            .thenApply(ResponseEntity::ok)
            .exceptionally(ex -> {
                log.error("Error getting validator info: {}", address, ex);
                return ResponseEntity.notFound().build();
            });
    }

    // ============ Green Projects ============

    @PostMapping("/projects")
    public CompletableFuture<ResponseEntity<Map<String, Object>>> createGreenProject(
            @RequestBody GreenProjectRequest request) {
        
        return web3Service.createGreenProject(
            request.getName(),
            request.getLocation(),
            request.getProjectType(),
            request.getFundingRequired(),
            request.getCo2ReductionTarget()
        )
            .thenApply(receipt -> {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("transactionHash", receipt.getTransactionHash());
                response.put("message", "Green project created successfully");
                return ResponseEntity.ok(response);
            })
            .exceptionally(ex -> {
                log.error("Error creating green project", ex);
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("error", ex.getMessage());
                return ResponseEntity.badRequest().body(response);
            });
    }

    @GetMapping("/projects/{projectId}")
    public CompletableFuture<ResponseEntity<Map<String, Object>>> getGreenProject(@PathVariable String projectId) {
        return web3Service.getGreenProject(new BigInteger(projectId))
            .thenApply(ResponseEntity::ok)
            .exceptionally(ex -> {
                log.error("Error getting green project: {}", projectId, ex);
                return ResponseEntity.notFound().build();
            });
    }

    @PostMapping("/projects/{projectId}/fund")
    public CompletableFuture<ResponseEntity<Map<String, Object>>> fundGreenProject(
            @PathVariable String projectId,
            @RequestBody FundProjectRequest request) {
        
        return web3Service.fundGreenProject(new BigInteger(projectId), request.getAmount())
            .thenApply(receipt -> {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("transactionHash", receipt.getTransactionHash());
                response.put("message", "Project funded successfully");
                return ResponseEntity.ok(response);
            })
            .exceptionally(ex -> {
                log.error("Error funding green project: {}", projectId, ex);
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("error", ex.getMessage());
                return ResponseEntity.badRequest().body(response);
            });
    }

    // ============ Transparency Functions ============

    @GetMapping("/transactions/user/{address}")
    public CompletableFuture<ResponseEntity<List<BigInteger>>> getUserTransactions(@PathVariable String address) {
        return web3Service.getUserTransactions(address)
            .thenApply(ResponseEntity::ok)
            .exceptionally(ex -> {
                log.error("Error getting user transactions: {}", address, ex);
                return ResponseEntity.internalServerError().build();
            });
    }

    // ============ Request/Response DTOs ============

    public static class ProductRequest {
        private String name;
        private BigDecimal basePrice;
        private BigInteger carbonEmission;

        // Getters and setters
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public BigDecimal getBasePrice() { return basePrice; }
        public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }
        public BigInteger getCarbonEmission() { return carbonEmission; }
        public void setCarbonEmission(BigInteger carbonEmission) { this.carbonEmission = carbonEmission; }
    }

    public static class PurchaseRequest {
        private BigDecimal totalAmount;

        public BigDecimal getTotalAmount() { return totalAmount; }
        public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    }

    public static class StakeRequest {
        private BigDecimal amount;

        public BigDecimal getAmount() { return amount; }
        public void setAmount(BigDecimal amount) { this.amount = amount; }
    }

    public static class GreenProjectRequest {
        private String name;
        private String location;
        private String projectType;
        private BigDecimal fundingRequired;
        private BigInteger co2ReductionTarget;

        // Getters and setters
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getLocation() { return location; }
        public void setLocation(String location) { this.location = location; }
        public String getProjectType() { return projectType; }
        public void setProjectType(String projectType) { this.projectType = projectType; }
        public BigDecimal getFundingRequired() { return fundingRequired; }
        public void setFundingRequired(BigDecimal fundingRequired) { this.fundingRequired = fundingRequired; }
        public BigInteger getCo2ReductionTarget() { return co2ReductionTarget; }
        public void setCo2ReductionTarget(BigInteger co2ReductionTarget) { this.co2ReductionTarget = co2ReductionTarget; }
    }

    public static class FundProjectRequest {
        private BigDecimal amount;

        public BigDecimal getAmount() { return amount; }
        public void setAmount(BigDecimal amount) { this.amount = amount; }
    }
}