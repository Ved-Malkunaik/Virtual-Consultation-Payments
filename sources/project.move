module MyModule::VirtualConsultationPayments {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Stores a doctor's consultation fee
    struct Doctor has key, store, drop {
        fee: u64,
    }

    /// Register or update a doctor's consultation fee
    public fun register_doctor(doctor: &signer, fee: u64) acquires Doctor {
        if (exists<Doctor>(signer::address_of(doctor))) {
            let old = move_from<Doctor>(signer::address_of(doctor));
            let _ = old; // Explicitly ignore the old resource for compatibility
        };
        move_to(doctor, Doctor { fee });
    }

    /// Patient pays the consultation fee to the doctor
    public fun pay_for_consultation(patient: &signer, doctor_addr: address) acquires Doctor {
        let doc = borrow_global<Doctor>(doctor_addr);
        let payment = coin::withdraw<AptosCoin>(patient, doc.fee);
        coin::deposit<AptosCoin>(doctor_addr, payment);
    }
}
