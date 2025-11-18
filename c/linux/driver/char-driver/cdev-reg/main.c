#include <linux/init.h>
#include <linux/module.h>
#include <linux/cdev.h>

#define DRIVER_NAME "testdriver"

static struct {
  dev_t devnum;
  struct cdev cdev;
} driver_data;


static ssize_t driver_write(struct file *file, const char __user *buf,
			    size_t count, loff_t *ppos)
{
	char kbuf = 0;
	if (copy_from_user(&kbuf, buf, 1))
		return -EFAULT;
  pr_info("%s: received char %c from user.\n", DRIVER_NAME, kbuf);
	return count;
}

static ssize_t driver_read(struct file *file, char __user *buf,
			   size_t count, loff_t *ppos)
{
	static const char * const msg = "Hi from driver\n";
	int size;
	if (*ppos > 0)
		return 0;
  size = strlen(msg);
  if (size > count)
    size = count;
	if (copy_to_user(buf, msg, size))
		return -EFAULT;
	*ppos += size;
	return size;
}

static const struct file_operations driver_fops = {
	.owner = THIS_MODULE,
	.write = driver_write,
	.read = driver_read,
};

static int __init my_init(void) {
  pr_info("%s: initializing\n", DRIVER_NAME);
  int result = 0;
  result = alloc_chrdev_region(&driver_data.devnum, 0, 1, DRIVER_NAME);
  if (result) {
    pr_err("%s: Failed to allocate device number\n", DRIVER_NAME);
    return result;
  }
  cdev_init(&driver_data.cdev, &driver_fops);
  result = cdev_add(&driver_data.cdev, driver_data.devnum, 1);
	if (result) {
		pr_err("%s: Char device registration failed!\n", DRIVER_NAME);
		unregister_chrdev_region(driver_data.devnum, 1);
		return result;
	}
  pr_info("%s: finished initialization\n", DRIVER_NAME);
  return 0;
}

static void __exit my_exit(void) {
  pr_info("%s: exiting\n", DRIVER_NAME);
  cdev_del(&driver_data.cdev);
  unregister_chrdev_region(driver_data.devnum, 1);
  pr_info("%s: finished exiting\n", DRIVER_NAME);
}

module_init(my_init);
module_exit(my_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Alex");
MODULE_VERSION("0.0");
