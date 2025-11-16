#include <linux/init.h>
#include <linux/module.h>

static int my_init() {
  printk(KERN_ALERT "Hello from custom driver running in kernel space.\n");
  return 0;
}

static void my_exit() {
  printk(KERN_ALERT "Exiting custom driver running in kernel space.\n");
}

module_init(my_init);
module_exit(my_exit);
