# Pavlov terraform in GCP
Terraform setup to deploy a [pavlov](https://pavlovwiki.com/index.php/Main_Page) server in Google Cloud Platform.

Google gives $300 for 3 months to test their product, this makes it easy to quickly set up a pavlov server in a new account (and also to take it down when needed)

## How to use

Clone this repo with 

```bash
git clone https://github.com/hammsvietro/pavlov_terraform_gcp
```

Edit `locals.tf` and `pavlov/Game.ini`

You can read [the server docs](http://wiki.pavlov-vr.com/index.php?title=Dedicated_server#Configuring_Game.ini) for more information about Game.ini and other files
<br><sub>go [here](https://pavlov-ms.vankrupt.com/servers/v1/key) to get an API key.</sub>

and also edit `pavlov/RconSettings.txt` to control the server using the Rcon tool, more info below.

Finally, run
```bash
terraform apply
```
to deploy the server, this will output the ip of your server. You can SSH into it at any time with with
```bash
ssh <instance_user>@<outputed_ip>
```

## Tip
#### Control the server via Rcon
[Arctic VR RCON](https://pavlovrcon.com/rcon/) is a good tool to control your server without the need to ssh into the instance.

### Contributing
Feel free to open an issue or a PR =)
