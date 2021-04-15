# Creacion de una instancia mailrelay Linux en red publica
resource "aws_instance" "vm-linux-pub-mailrelay" {
        # CentOS 7 (x86_64) - with Updates HVM
        ami = "ami-9887c6e7"
        instance_type = "t2.medium"
        subnet_id = "${aws_subnet.pub-subnet-1.id}"
        vpc_security_group_ids = [
            "${aws_security_group.SG_SSH.id}",
            "${aws_security_group.SG_SMTP.id}",
        ]
        key_name = "${aws_key_pair.KP-arengifo.id}"
        tags {  
                Name = "vm-linux-pub-mailrelay"
        }
}

# Creacion de una IP elastica para el mailrelay
resource "aws_eip" "EIP-linux-pub-mailrelay" {
    instance = "${aws_instance.vm-linux-pub-mailrelay.id}"
    vpc      = true
    tags {
        Name = "EIP-linux-pub-mailrelay"
    }
}
