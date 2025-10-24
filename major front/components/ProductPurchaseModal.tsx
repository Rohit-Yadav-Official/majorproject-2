import { useState } from 'react';
import { Button } from './ui/Button';
import { Modal } from './ui/Modal';
import { 
  ShoppingCart, 
  Leaf, 
  AlertTriangle, 
  Calculator,
  TreePine,
  Zap,
  CheckCircle,
  Clock
} from 'lucide-react';
import toast from 'react-hot-toast';
import { web3Service } from '../src/services/web3Service';

interface Product {
  id: number;
  name: string;
  basePrice: number;
  carbonTax: number;
  co2Emission: number;
  category: string;
  description?: string;
  manufacturer?: string;
}

interface ProductPurchaseModalProps {
  product: Product | null;
  isOpen: boolean;
  onClose: () => void;
  onPurchaseComplete?: () => void;
}

export function ProductPurchaseModal({ 
  product, 
  isOpen, 
  onClose, 
  onPurchaseComplete 
}: ProductPurchaseModalProps) {
  const [isProcessing, setIsProcessing] = useState(false);
  const [quantity, setQuantity] = useState(1);
  const [showConfirmation, setShowConfirmation] = useState(false);

  if (!product) return null;

  const totalBasePrice = product.basePrice * quantity;
  const totalCarbonTax = product.carbonTax * quantity;
  const totalCO2 = product.co2Emission * quantity;
  const grandTotal = totalBasePrice + totalCarbonTax;

  const handlePurchase = async () => {
    if (!web3Service.isConnected()) {
      toast.error('Please connect your wallet first');
      return;
    }

    setIsProcessing(true);
    try {
      // Call the smart contract purchase function
      const success = await web3Service.purchaseProduct(product.id);
      
      if (success) {
        setShowConfirmation(true);
        toast.success('Purchase completed successfully!');
        
        // Call callback after successful purchase
        setTimeout(() => {
          onPurchaseComplete?.();
          handleClose();
        }, 3000);
      } else {
        toast.error('Purchase failed. Please try again.');
      }
    } catch (error) {
      console.error('Purchase error:', error);
      toast.error('Transaction failed. Check your wallet and try again.');
    } finally {
      setIsProcessing(false);
    }
  };

  const handleClose = () => {
    setQuantity(1);
    setShowConfirmation(false);
    setIsProcessing(false);
    onClose();
  };

  const getCategoryIcon = (category: string) => {
    switch (category.toLowerCase()) {
      case 'electronics':
        return <Zap className="h-5 w-5 text-blue-600" />;
      case 'clothing':
        return <Leaf className="h-5 w-5 text-green-600" />;
      default:
        return <ShoppingCart className="h-5 w-5 text-gray-600" />;
    }
  };

  const getEmissionLevel = (co2: number) => {
    if (co2 < 50) return { level: 'Low', color: 'text-green-600', bgColor: 'bg-green-50' };
    if (co2 < 200) return { level: 'Medium', color: 'text-yellow-600', bgColor: 'bg-yellow-50' };
    return { level: 'High', color: 'text-red-600', bgColor: 'bg-red-50' };
  };

  if (showConfirmation) {
    return (
      <Modal isOpen={isOpen} onClose={handleClose} title="Purchase Confirmed">
        <div className="text-center space-y-6">
          <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto">
            <CheckCircle className="h-10 w-10 text-green-600" />
          </div>
          
          <div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">
              Transaction Successful!
            </h3>
            <p className="text-gray-600">
              Your purchase has been recorded on the blockchain and carbon tax has been collected.
            </p>
          </div>

          <div className="bg-green-50 p-4 rounded-lg">
            <div className="flex items-center justify-center space-x-2 mb-2">
              <TreePine className="h-5 w-5 text-green-600" />
              <span className="font-medium text-green-800">Environmental Impact</span>
            </div>
            <p className="text-sm text-green-700">
              Your carbon tax of <strong>${totalCarbonTax.toFixed(2)}</strong> will fund renewable energy projects 
              to offset <strong>{totalCO2}g CO₂</strong> emissions.
            </p>
          </div>

          <div className="text-sm text-gray-500">
            <div className="flex items-center justify-center space-x-1">
              <Clock className="h-4 w-4" />
              <span>This window will close automatically in a few seconds...</span>
            </div>
          </div>
        </div>
      </Modal>
    );
  }

  return (
    <Modal isOpen={isOpen} onClose={handleClose} title="Purchase Product">
      <div className="space-y-6">
        {/* Product Header */}
        <div className="flex items-start space-x-4">
          <div className="w-12 h-12 bg-gray-100 rounded-lg flex items-center justify-center">
            {getCategoryIcon(product.category)}
          </div>
          <div className="flex-1">
            <h3 className="text-lg font-semibold text-gray-900">{product.name}</h3>
            <p className="text-sm text-gray-500">{product.category}</p>
            {product.manufacturer && (
              <p className="text-xs text-gray-400">by {product.manufacturer}</p>
            )}
          </div>
        </div>

        {/* Quantity Selection */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">Quantity</label>
          <div className="flex items-center space-x-3">
            <button
              onClick={() => setQuantity(Math.max(1, quantity - 1))}
              className="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center hover:bg-gray-50"
              disabled={quantity <= 1}
            >
              -
            </button>
            <span className="w-12 text-center font-medium">{quantity}</span>
            <button
              onClick={() => setQuantity(quantity + 1)}
              className="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center hover:bg-gray-50"
            >
              +
            </button>
          </div>
        </div>

        {/* Environmental Impact */}
        <div className={`p-4 rounded-lg ${getEmissionLevel(totalCO2).bgColor}`}>
          <div className="flex items-center space-x-2 mb-2">
            <Leaf className="h-5 w-5 text-gray-600" />
            <span className="font-medium">Environmental Impact</span>
            <span className={`text-xs px-2 py-1 rounded-full ${getEmissionLevel(totalCO2).color} bg-white`}>
              {getEmissionLevel(totalCO2).level}
            </span>
          </div>
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <p className="text-gray-600">CO₂ Emissions</p>
              <p className="font-semibold">{totalCO2}g per purchase</p>
            </div>
            <div>
              <p className="text-gray-600">Annual Equivalent</p>
              <p className="font-semibold">{(totalCO2 * 52 / 1000).toFixed(1)}kg CO₂/year</p>
            </div>
          </div>
        </div>

        {/* Price Breakdown */}
        <div className="border rounded-lg p-4">
          <div className="flex items-center space-x-2 mb-3">
            <Calculator className="h-5 w-5 text-gray-600" />
            <span className="font-medium">Price Breakdown</span>
          </div>
          
          <div className="space-y-2">
            <div className="flex justify-between">
              <span className="text-gray-600">Base Price ({quantity}x)</span>
              <span>${totalBasePrice.toFixed(2)}</span>
            </div>
            
            <div className="flex justify-between items-center">
              <div className="flex items-center space-x-2">
                <span className="text-gray-600">Carbon Tax</span>
                <AlertTriangle className="h-4 w-4 text-orange-500" />
              </div>
              <span className="text-red-600 font-medium">${totalCarbonTax.toFixed(2)}</span>
            </div>
            
            <div className="border-t pt-2">
              <div className="flex justify-between font-semibold text-lg">
                <span>Total</span>
                <span>${grandTotal.toFixed(2)}</span>
              </div>
            </div>
          </div>
        </div>

        {/* Carbon Tax Information */}
        <div className="bg-blue-50 p-4 rounded-lg">
          <div className="flex items-start space-x-3">
            <TreePine className="h-5 w-5 text-blue-600 mt-0.5" />
            <div className="text-sm text-blue-800">
              <p className="font-medium mb-1">Where Your Carbon Tax Goes</p>
              <p>
                Your ${totalCarbonTax.toFixed(2)} carbon tax will be transparently allocated to verified 
                renewable energy projects that offset your purchase's environmental impact. 
                Track the funds in real-time through our Transparency Portal.
              </p>
            </div>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="flex space-x-3">
          <Button 
            onClick={handleClose}
            variant="secondary"
            className="flex-1"
          >
            Cancel
          </Button>
          <Button 
            onClick={handlePurchase}
            disabled={isProcessing}
            className="flex-1"
          >
            {isProcessing ? (
              <div className="flex items-center space-x-2">
                <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                <span>Processing...</span>
              </div>
            ) : (
              <div className="flex items-center space-x-2">
                <ShoppingCart className="h-4 w-4" />
                <span>Purchase ${grandTotal.toFixed(2)}</span>
              </div>
            )}
          </Button>
        </div>

        {/* Disclaimer */}
        <div className="text-xs text-gray-500 text-center">
          By purchasing, you agree to pay the carbon tax which supports environmental initiatives. 
          All transactions are recorded on the blockchain for transparency.
        </div>
      </div>
    </Modal>
  );
}