import React from 'react';
import SuiDialog from './SuiDialog';

import Button from '@mui/material/Button';
import { useCurrentAccount } from "@mysten/dapp-kit";
function Transfer() {
    const account = useCurrentAccount();

    const [digest, setDigest] = React.useState('');
    const [openDialog, setOpenDialog] = React.useState(false);

    const handleOpenDialog = () => {
        setOpenDialog(true);
    };


    return (
        <>
            {account ? <>
                <Button variant='contained' color='secondary' onClick={() => handleOpenDialog()}>Click to create new Transaction!</Button>
                <SuiDialog open={openDialog} setOpen={setOpenDialog} setDigest={setDigest} />
                <div>Digest Transaction: {digest}</div>
            </> : <div>Please connect wallet before creating new Transaction!!!!</div>}
        </>
    )
}

export default Transfer