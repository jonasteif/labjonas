variable "project_name" {
    type = string
    default = "labjonas"
}

// Declarar os ids das subnets da vpc padrao 
variable "subnets" {
    type = list
    default = ["subnet-<valor>", "subnet-<valor>", "subnet-<valor>" ]
}

variable "credential_file" {
    type = string
    default = "<inserir aqui path das credenciais da aws>"
}

//declarar em default id da vpc padrao
variable "vpc_name" {
    type = string
    default = "<inserir nome da vpc padrao>"
}


//inserir em default = o valor da ami do ubuntu 18 da regiao utilizada, no exemplo abaixo está o id da ami da regiao eu-west-1
variable "ami" {
    type = string
    default = "ami-035966e8adab4aaad"
}

variable "instance_name1" {
    type = string
    default = "nginx"
}

//Colocar vamor da chave ssh caso necessario posterior acesso ssh nas instancias EC2
variable "key_name" {
    type = string
    default = "<valor>"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "instance_name2" {
    type = string
    default = "apache"
}
// colocar o nome da região, por padrão utilizei eu-west-1
variable "region" {
    type = string
    default =  "<colocar codigo da regiao>"
}