import * as React from 'react';
import Button from '@mui/material/Button';
import { styled } from '@mui/material/styles';
import Dialog from '@mui/material/Dialog';
import DialogTitle from '@mui/material/DialogTitle';
import DialogContent from '@mui/material/DialogContent';
import DialogActions from '@mui/material/DialogActions';
import IconButton from '@mui/material/IconButton';
import CloseIcon from '@mui/icons-material/Close';
import TextField from '@mui/material/TextField';
import Typography from '@mui/material/Typography';
import { Transaction } from '@mysten/sui/transactions';
import { useSignAndExecuteTransaction } from '@mysten/dapp-kit';

const BootstrapDialog = styled(Dialog)(({ theme }) => ({
    '& .MuiDialogContent-root': {
        padding: theme.spacing(2),
    },
    '& .MuiDialogActions-root': {
        padding: theme.spacing(1),
    },
}));

interface SuiDialogProps {
    open: boolean;
    setOpen: (open: boolean) => void;
    setDigest: (digest: string) => void
}

const isValidSuiAddress = (address: string): boolean => {
    // Simple regex for example; adjust according to Sui address format
    const suiAddressRegex = /^0x[a-fA-F0-9]{64}$/;
    return suiAddressRegex.test(address);
};

export default function SuiDialog({ open, setOpen, setDigest }: SuiDialogProps) {
    const [amount, setAmount] = React.useState<number | ''>('');
    const [address, setAddress] = React.useState<string>('');
    const [isAddressValid, setIsAddressValid] = React.useState<boolean>(false);
    const { mutateAsync: signAndExecuteTransactionBlock } = useSignAndExecuteTransaction();

    const handleClose = () => {
        setOpen(false);
    };

    const handleAmountChange = (event: React.ChangeEvent<HTMLInputElement>) => {
        const value = event.target.value === '' ? '' : parseFloat(event.target.value);
        setAmount(value);
    };

    const handleAddressChange = (event: React.ChangeEvent<HTMLInputElement>) => {
        const value = event.target.value;
        setAddress(value);
        setIsAddressValid(isValidSuiAddress(value));
    };



    function sendSui() {
        setTimeout(() => {
            handleClose();
        }, 500);
        console.log('Amount:', amount);
        console.log('Sui Address:', address);

        const txb = new Transaction();

        const coin = txb.splitCoins(txb.gas, [amount]);
        txb.transferObjects([coin], address);

        signAndExecuteTransactionBlock({
            transaction: txb,
        }).then(async (_result) => {
            setDigest(_result.digest);
            alert('Sui sent successfully');
        }).catch((error) => {
            alert(error);
        });
    }

    return (
        <React.Fragment>
            <BootstrapDialog
                onClose={handleClose}
                aria-labelledby="customized-dialog-title"
                open={open}
            >
                <DialogTitle sx={{ m: 0, p: 2 }} id="customized-dialog-title">
                    Sui Dapp
                </DialogTitle>
                <IconButton
                    aria-label="close"
                    onClick={handleClose}
                    sx={(theme) => ({
                        position: 'absolute',
                        right: 8,
                        top: 8,
                        color: theme.palette.grey[500],
                    })}
                >
                    <CloseIcon />
                </IconButton>
                <DialogContent dividers>
                    <Typography gutterBottom>
                        Input the amount and receiving Sui address:
                    </Typography>
                    <form>
                        <TextField
                            fullWidth
                            label="Amount Sui"
                            type="number"
                            value={amount}
                            onChange={handleAmountChange}
                            margin="normal"
                        />
                        <TextField
                            fullWidth
                            label="Receive Address Sui"
                            type="text"
                            value={address}
                            onChange={handleAddressChange}
                            error={!isAddressValid && address !== ''}
                            helperText={
                                !isAddressValid && address !== ''
                                    ? 'Please enter a valid Sui address.'
                                    : ''
                            }
                            margin="normal"
                        />
                    </form>
                </DialogContent>
                <DialogActions>
                    <Button
                        variant='contained' color='primary'
                        onClick={sendSui}
                        disabled={!isAddressValid || amount === ''}
                        autoFocus
                    >
                        Send SUI
                    </Button>
                </DialogActions>
            </BootstrapDialog>
        </React.Fragment>
    );
}
