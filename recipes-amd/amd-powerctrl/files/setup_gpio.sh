#!/bin/bash

# Set all output GPIOs as such and drive them with reasonable values.
function set_gpio_active_low() {
  if [ $# -ne 3 ]; then
    echo "set_gpio_active_low: need GPIO#, active_low and initial value";
    return;
  fi

  echo $1 > /sys/class/gpio/export
  echo $2 > /sys/class/gpio/gpio$1/active_low
  echo $3 > /sys/class/gpio/gpio$1/direction
}

GPIO_BASE=$(cat /sys/devices/platform/ahb/ahb:apb/1e780000.gpio/gpio/*/base)
# MGMT_ASSERT_BMC_READY - Hold low until BMC has completed initialization, then drive high, GPIO M7,  (Default = Low)
GPIO_BMC_READY=$((${GPIO_BASE} + 96 + 7))

#MGMT_ASSERT_PWR_BTN - Asserts the system power button, GPIO M0, Active High,  (Default = Low)
set_gpio_active_low $((${GPIO_BASE} + 96 + 0)) 0 low

#MGMT_ASSERT_RST_BTN - Assert the system cold reset button, GPIO M1, Active High,  (Default = Low)
set_gpio_active_low $((${GPIO_BASE} + 96 + 1)) 0 low

#MGMT_ASSERT_NMI_BTN - Asserts the system NMI button, GPIO M2 Active High,  (Default = Low)
set_gpio_active_low $((${GPIO_BASE} + 96 + 2)) 0 low

#MGMT_ASSERT_P0_PROCHOT - Asserts the P0 PROCHOT_L signal, GPIO M4, Active High,  (Default = Low)
set_gpio_active_low $((${GPIO_BASE} + 96 + 4)) 0 low

#MGMT_ASSERT_P1_PROCHOT - Asserts the P1 PROCHOT_L signal, GPIO M6, Active High,  (Default = Low)
set_gpio_active_low $((${GPIO_BASE} + 96 + 5)) 0 low

#MGMT_ASSERT_CLR_CMOS - Clears processor CMOS, assert high for 1s To clear CMOS,  (Default = Low)
set_gpio_active_low $((${GPIO_BASE} + 96 + 6)) 0 low

# MGMT_ASSERT_BMC_READY - Hold low until BMC has completed initialization, then drive high, GPIO M7,  (Default = Low)
set_gpio_active_low $((${GPIO_BASE} + 96 + 7)) 0 low

# DRIVE BMC_READY HIGH
echo 1 > /sys/class/gpio/gpio${GPIO_BMC_READY}/value
POWER_STATUS=on
# Write to temp. file named "power_status"
rm -f /tmp/power_status
printf %s "$POWER_STATUS" > /tmp/power_status
exit 0;
