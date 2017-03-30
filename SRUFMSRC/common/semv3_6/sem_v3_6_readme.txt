CHANGE LOG for Soft Error Mitigation v3.6

Release Date:  June 19, 2013
--------------------------------------------------------------------------------


Table of Contents

1. INTRODUCTION
2. DEVICE SUPPORT
3. NEW FEATURE HISTORY
4. RESOLVED ISSUES
5. KNOWN ISSUES & LIMITATIONS
6. TECHNICAL SUPPORT & FEEDBACK
7. CORE RELEASE HISTORY
8. LEGAL DISCLAIMER


--------------------------------------------------------------------------------


1. INTRODUCTION

  This file contains the change log for all released versions of the Xilinx
  LogiCORE IP core Soft Error Mitigation in ISE.

  For the latest core updates, see the product page at:

    http://www.xilinx.com/products/intellectual-property/SEM.htm

  For installation instructions for this release, please go to:

    http://www.xilinx.com/ipcenter/coregen/ip_update_install_instructions.htm

  For system requirements, see:

    http://www.xilinx.com/ipcenter/coregen/ip_update_system_requirements.htm


2. DEVICE SUPPORT 

    The following device families are supported by the core for this release:

    All Artix-7 devices                             (v3.4 or later)
    All Zynq-7000 devices                           (v3.4 or later)
    All Virtex-7 devices (excluding SSI)            (v3.1 or later)
    All Kintex-7 devices                            (v3.1 or later)
    All Virtex-6 devices                            (v1.1 or later)
    All Spartan-6 devices                           (v2.1 or later)


3. NEW FEATURE HISTORY

    v3.6

    - None

    v3.5

    - None

    v3.4

    - Added support for Artix-7 and Zynq-7000 devices.

    - An updated Spartan-6 solution is available based on a Design Advisory
      for Spartan-6 FPGAs Configuration Readback feature.  See AR 52716.

    - Added new parameters for Spartan-6: enable_bottom_gt_scan, 
      enable_top_gt_scan.

    v3.3

    - None


4. RESOLVED ISSUES

    The following issues are resolved in the indicated IP versions:

    v3.6

    - For Spartan-6 devices, corrected the reported scan start frame.
      When scanning of the bottom device row next to the GT is disabled, the
      controller was properly skipping the row but incorrectly reporting
      the scan start frame as zero.  The report now correctly indicates the
      actual scan start frame.

      - AR 55277

    v3.5

    - For 7 Series devices, the maximum clock frequency is increased up to
      100 MHz to match the FRBCCK configuration interface AC timing parameter
      listed in the relevant 7 Series FPGA data sheet.

      - AR 47402
    
    - When configuring this IP core with the Correction by Replace or 
      Classification features enabled, the generated EXT shim module will
      enable additional SPI Flash configuration commands as needed to support
      the density of SPI Flash required. Refer to the answer records for
      further information on setting these parameters for your storage device.

      - AR 54285 
      - AR 53438

    v3.4

    - An updated Spartan-6 solution is available based on a Design Advisory
      for Spartan-6 FPGAs Configuration Readback feature.

      - AR 52716

    v3.3

    - Bitstream length changes for the XC7VX550T and XC7K420T devices
      required modification to the IP core.  Customers targeting these
      devices must update to v3.3 of this IP core and review the updated
      solution metrics (resource usage, latencies, storage requirements)
      for these devices in the IP core product guide.

      - AR 50778


5. KNOWN ISSUES & LIMITATIONS

    - When performing timing simulation of an application that contains the
      example design provided with this core, the following type of warning
      may occur if the example design has been configured to include ChipScope:

      "X_FF RECOVERY LOW VIOLATION ON RST WITH RESPECT TO CLK"
      (issued from instances in the ChipScope logic)

      Such warnings result from the signal activity detector circuits used
      in ChipScope, which are asynchronous to the IP core signals being
      monitored. The warnings can safely be ignored.

      - AR 39350

    - Spartan-6 implementations of this IP core may generate a component
      switching limit timing error in map, par, and trce:

      "WARNING:Pack:2768 - At least one timing constraint is impossible to
      meet because component switching limit violations have been detected
      for a constrained component."

      This issue may be safely ignored if trce indicates that this component
      switching limit error is on net 'clk_IBUFG' for clock network 'icap_clk',
      and indicates that the minimum clock period is 250 ns (4 MHz) for S6 -1L
      devices, 50 ns (20 MHz) for S6 LX4-LX75 devices, or 83.333 ns (12 MHz)
      for S6 LX100-LX150 devices.

      The Spartan-6 controller performs configuration readback through the ICAP
      excluding type 1 frames (Block RAM contents).  This allows the ICAP to be
      clocked at a higher rate than reported by the tools.  Refer to DS162 for
      the maximum ICAP readback frequency (F_RBCCK) ignoring Block RAM.

      - AR 42483

    - Spartan-6 implementations of this IP core may generate warnings about
      the use of 9K Block RAM instances in map or bitgen:

      "WARNING:PhysDesignRules:2410 - This design is using one or more 9K
      Block RAMs (RAMB8BWER).  9K Block RAM initialization data, both user
      defined and default, may be incorrect and should not be used.  For
      more information, please reference Xilinx Answer Record 39999."

      This issue may be safely ignored, as any 9K BlockRAM instances in the
      Spartan-6 controller implementation are initialized at run-time by the
      controller.  This process overwrites any pre-existing data in the 9K
      BlockRAM instances.

      - AR 39999
      - AR 41955

    - 7 Series implementations of this IP core may generate DRC errors about
      I/O pins without location constraints or signaling standards defined.

      The UCF provided for the example design targeting 7 Series devices
      does not have LOC constraints, although it does contain IOSTANDARD
      constraints.  To evaluate the example design in hardware, appropriate
      LOC constraints must be added.  Further, the IOSTANDARD constraints
      must be reviewed and adjusted if necessary based on the LOC constraints
      and the I/O bank voltages in use.

      The implementation scripts targeting 7 Series devices have bitgen
      and any dependent steps commented out.  After making modifications
      to the UCF, the script should be modified to enable these steps.

      - AR 41615

  - For a comprehensive listing of known issues and limitations for this core,
    please see the IP Release Notes Guide at:

    http://www.xilinx.com/support/documentation/user_guides/xtp025.pdf


6. TECHNICAL SUPPORT & FEEDBACK

   To obtain technical support, create a WebCase at www.xilinx.com/support.
   Questions are routed to a team with expertise using this product.
   Feedback on this IP core may also be submitted under the "Leave Feedback"
   menu item in Vivado/PlanAhead.

   Xilinx provides technical support for use of this product when used
   according to the guidelines described in the core documentation, and
   cannot guarantee timing, functionality, or support of this product for
   designs that do not follow specified guidelines.


7. CORE RELEASE HISTORY

Date        By            Version      Description
================================================================================
06/19/2013  Xilinx, Inc.  3.6          Released for ISE 14.6.

03/20/2013  Xilinx, Inc.  3.5          Released for ISE 14.5.

12/18/2012  Xilinx, Inc.  3.4          Released for ISE 14.4. Added support for 
                                       Artix-7 and Zynq-7000 devices. Updated 
                                       Spartan-6 solution.

07/25/2012  Xilinx, Inc.  3.3          Released for ISE 14.2.

04/24/2012  Xilinx, Inc.  3.2          Released for ISE 14.1. Added support for 
                                       Defense Grade Virtex-7Q and Kintex-7Q 
                                       devices.

10/19/2011  Xilinx, Inc.  3.1          Released for ISE 13.3.  Added support
                                       for Virtex-7 and Kintex-7 (excluding
                                       SSI) devices.

06/22/2011  Xilinx, Inc.  2.1          Released for ISE 13.2.  Added support
                                       for Spartan-6, QVirtex-6 and QVirtex-6
                                       -1L devices.

03/01/2011  Xilinx, Inc.  1.3          Released for ISE 13.1.

12/14/2010  Xilinx, Inc.  1.2          Released for ISE 12.4.

09/21/2010  Xilinx, Inc.  1.1          Released for ISE 12.3.
================================================================================


8. LEGAL DISCLAIMER

  (c) Copyright 2010 - 2013 Xilinx, Inc. All rights reserved.

  This file contains confidential and proprietary information
  of Xilinx, Inc. and is protected under U.S. and
  international copyright and other intellectual property
  laws.

  DISCLAIMER
  This disclaimer is not a license and does not grant any
  rights to the materials distributed herewith. Except as
  otherwise provided in a valid license issued to you by
  Xilinx, and to the maximum extent permitted by applicable
  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
  (2) Xilinx shall not be liable (whether in contract or tort,
  including negligence, or under any other theory of
  liability) for any loss or damage of any kind or nature
  related to, arising under or in connection with these
  materials, including for any direct, or any indirect,
  special, incidental, or consequential loss or damage
  (including loss of data, profits, goodwill, or any type of
  loss or damage suffered as a result of any action brought
  by a third party) even if such damage or loss was
  reasonably foreseeable or Xilinx had been advised of the
  possibility of the same.

  CRITICAL APPLICATIONS
  Xilinx products are not designed or intended to be fail-
  safe, or for use in any application requiring fail-safe
  performance, such as life-support or safety devices or
  systems, Class III medical devices, nuclear facilities,
  applications related to the deployment of airbags, or any
  other applications that could lead to death, personal
  injury, or severe property or environmental damage
  (individually and collectively, "Critical
  Applications"). Customer assumes the sole risk and
  liability of any use of Xilinx products in Critical
  Applications, subject only to applicable laws and
  regulations governing limitations on product liability.

  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
  PART OF THIS FILE AT ALL TIMES.
