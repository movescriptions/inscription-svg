#[lint_allow(self_transfer)]
module inscription_lab::inscription_svg {
    use sui::tx_context::{Self, TxContext};
    use std::string::{utf8, String};
    use std::vector;
    use sui::transfer;
    use sui::object::{Self, UID};

    use sui::package;
    use sui::display;

    struct Inscription has key, store {
        id: UID,
        p: String,
        op: String,
        tick: String,
        amt: u64,
    }

    /// One-Time-Witness for the module.
    struct INSCRIPTION_SVG has drop {}

    fun init(otw: INSCRIPTION_SVG, ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"p"),
            utf8(b"op"),
            utf8(b"tick"),
            utf8(b"amt"),
            utf8(b"image_url"),
        ];



        let p = b"{p}";
        let op = b"{op}";
        let tick = b"{tick}";
        let amt = b"{amt}";

        let img_metadata = generateSVG(p,op,tick,amt);

        let values = vector[
            utf8(b"{p}"),
            utf8(b"{op}"),
            utf8(b"{tick}"),
            utf8(b"{amt}"),
            utf8(img_metadata),
        ];

        // Claim the `Publisher` for the package!
        let publisher = package::claim(otw, ctx);

        // Get a new `Display` object for the `Hero` type.
        let display = display::new_with_fields<Inscription>(
            &publisher, keys, values, ctx
        );

        // Commit first version of `Display` to apply changes.
        display::update_version(&mut display);
        
        let sender = tx_context::sender(ctx);

        transfer::public_transfer(publisher, sender);
        transfer::public_transfer(display, sender);
    }

    /// Anyone can mint their `Hero`!
    public fun mint(ctx: &mut TxContext) {
        let id = object::new(ctx);
        let suis = Inscription { id, p: utf8(b"suis-20"),op:utf8(b"mint"),tick:utf8(b"SUIS"), amt:924 };
        let sender = tx_context::sender(ctx);
        transfer::public_transfer(suis, sender);
    }

    const SVG_PATH_1:vector<u8> = b"data:image/svg+xml,%3Csvg%20width%3D%22120%22%20height%3D%22120%22%20viewBox%3D%220%200%20120%20120%22%20fill%3D%22none%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3E%3Crect%20width%3D%22120%22%20height%3D%22120%22%20fill%3D%22%234CA2FF%22%2F%3E%3Ctext%20fill%3D%22%23EAF7FF%22%20xml%3Aspace%3D%22preserve%22%20style%3D%22white-space%3A%20pre%22%20font-family%3D%22Inter%22%20font-size%3D%2212%22%20letter-spacing%3D%220em%22%3E%3Ctspan%20x%3D%2215%22%20y%3D%2226.8636%22%3E%7B%26%2310%3B%3C%2Ftspan%3E%3Ctspan%20x%3D%2215%22%20y%3D%2241.8636%22%3E%20%20%20%20p%3A%20%26%2339%3B";
    
    // apt-20
    
    const SVG_PATH_2:vector<u8> = b"%26%2339%3B%2C%26%2310%3B%3C%2Ftspan%3E%3Ctspan%20x%3D%2215%22%20y%3D%2256.8636%22%3E%20%20%20%20op%3A%20%26%2339%3B";
    
    // mint
    
    const SVG_PATH_3:vector<u8> = b"%26%2339%3B%2C%26%2310%3B%3C%2Ftspan%3E%3Ctspan%20x%3D%2215%22%20y%3D%2271.8636%22%3E%20%20%20%20tick%3A%20%26%2339%3B";
    
    // APTS
    
    const SVG_PATH_4:vector<u8> = b"%26%2339%3B%2C%26%2310%3B%3C%2Ftspan%3E%3Ctspan%20x%3D%2215%22%20y%3D%2286.8636%22%3E%20%20%20%20amt%3A%20";
    
    // 2139
    
    const SVG_PATH_5:vector<u8> = b"%26%2310%3B%3C%2Ftspan%3E%3Ctspan%20x%3D%2215%22%20y%3D%22101.864%22%3E%7D%3C%2Ftspan%3E%3C%2Ftext%3E%3C%2Fsvg%3E";

    public fun generateSVG(p:vector<u8>,op:vector<u8>,tick:vector<u8>,amt:vector<u8>):vector<u8>{
      let metadata = SVG_PATH_1;
      vector::append(&mut metadata, p);
      vector::append(&mut metadata, SVG_PATH_2);
      vector::append(&mut metadata, op);
      vector::append(&mut metadata, SVG_PATH_3);
      vector::append(&mut metadata, tick);
      vector::append(&mut metadata, SVG_PATH_4);
      vector::append(&mut metadata, amt);
      vector::append(&mut metadata, SVG_PATH_5);

      metadata
    }
}