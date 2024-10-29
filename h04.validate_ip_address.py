#Day4: write a function to validate if a string is valid ip address or not.
#a valid ip address should be in form of x1.x2.x3.x4 where
#x1,x2,x3,x4 should be numbers between 0 and 255

def isvalid_ip(s):
	ip_list = s.split('.') #to_create_list
	if len(ip_list) != 4:
		return False
	for n  in ip_list:
		if n.isdigit() == False:
			return False
		if int(n) < 0 or int(n) > 255:
			return False

	return True



print(isvalid_ip('255.23.12.23')) #True
print(isvalid_ip('255.23.12.278')) #False
print(isvalid_ip('255.23.12.-2'))  #False
print(isvalid_ip('255.23.12.2.12')) #False
print(isvalid_ip('255.23.12.a')) #False
