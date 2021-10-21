	component lab61soc is
		port (
			clk_clk                        : in    std_logic                     := 'X';             -- clk
			reset_reset_n                  : in    std_logic                     := 'X';             -- reset_n
			sdram_clk_clk                  : out   std_logic;                                        -- clk
			sdram_wire_addr                : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_wire_ba                  : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_wire_cas_n               : out   std_logic;                                        -- cas_n
			sdram_wire_cke                 : out   std_logic;                                        -- cke
			sdram_wire_cs_n                : out   std_logic;                                        -- cs_n
			sdram_wire_dq                  : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_wire_dqm                 : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_wire_ras_n               : out   std_logic;                                        -- ras_n
			sdram_wire_we_n                : out   std_logic;                                        -- we_n
			keycode_export                 : out   std_logic_vector(7 downto 0);                     -- export
			usb_irq_export                 : in    std_logic                     := 'X';             -- export
			usb_gpx_export                 : in    std_logic                     := 'X';             -- export
			usb_rst_export                 : out   std_logic;                                        -- export
			hex_digits_export              : out   std_logic_vector(15 downto 0);                    -- export
			leds_export                    : out   std_logic_vector(13 downto 0);                    -- export
			key_external_connection_export : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- export
			irq_2_irq                      : out   std_logic;                                        -- irq
			irq_3_irq                      : out   std_logic;                                        -- irq
			spi0_writedata                 : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			spi0_readdata                  : out   std_logic_vector(15 downto 0);                    -- readdata
			spi0_address                   : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- address
			spi0_read_n                    : in    std_logic                     := 'X';             -- read_n
			spi0_chipselect                : in    std_logic                     := 'X';             -- chipselect
			spi0_write_n                   : in    std_logic                     := 'X'              -- write_n
		);
	end component lab61soc;

	u0 : component lab61soc
		port map (
			clk_clk                        => CONNECTED_TO_clk_clk,                        --                     clk.clk
			reset_reset_n                  => CONNECTED_TO_reset_reset_n,                  --                   reset.reset_n
			sdram_clk_clk                  => CONNECTED_TO_sdram_clk_clk,                  --               sdram_clk.clk
			sdram_wire_addr                => CONNECTED_TO_sdram_wire_addr,                --              sdram_wire.addr
			sdram_wire_ba                  => CONNECTED_TO_sdram_wire_ba,                  --                        .ba
			sdram_wire_cas_n               => CONNECTED_TO_sdram_wire_cas_n,               --                        .cas_n
			sdram_wire_cke                 => CONNECTED_TO_sdram_wire_cke,                 --                        .cke
			sdram_wire_cs_n                => CONNECTED_TO_sdram_wire_cs_n,                --                        .cs_n
			sdram_wire_dq                  => CONNECTED_TO_sdram_wire_dq,                  --                        .dq
			sdram_wire_dqm                 => CONNECTED_TO_sdram_wire_dqm,                 --                        .dqm
			sdram_wire_ras_n               => CONNECTED_TO_sdram_wire_ras_n,               --                        .ras_n
			sdram_wire_we_n                => CONNECTED_TO_sdram_wire_we_n,                --                        .we_n
			keycode_export                 => CONNECTED_TO_keycode_export,                 --                 keycode.export
			usb_irq_export                 => CONNECTED_TO_usb_irq_export,                 --                 usb_irq.export
			usb_gpx_export                 => CONNECTED_TO_usb_gpx_export,                 --                 usb_gpx.export
			usb_rst_export                 => CONNECTED_TO_usb_rst_export,                 --                 usb_rst.export
			hex_digits_export              => CONNECTED_TO_hex_digits_export,              --              hex_digits.export
			leds_export                    => CONNECTED_TO_leds_export,                    --                    leds.export
			key_external_connection_export => CONNECTED_TO_key_external_connection_export, -- key_external_connection.export
			irq_2_irq                      => CONNECTED_TO_irq_2_irq,                      --                   irq_2.irq
			irq_3_irq                      => CONNECTED_TO_irq_3_irq,                      --                   irq_3.irq
			spi0_writedata                 => CONNECTED_TO_spi0_writedata,                 --                    spi0.writedata
			spi0_readdata                  => CONNECTED_TO_spi0_readdata,                  --                        .readdata
			spi0_address                   => CONNECTED_TO_spi0_address,                   --                        .address
			spi0_read_n                    => CONNECTED_TO_spi0_read_n,                    --                        .read_n
			spi0_chipselect                => CONNECTED_TO_spi0_chipselect,                --                        .chipselect
			spi0_write_n                   => CONNECTED_TO_spi0_write_n                    --                        .write_n
		);

