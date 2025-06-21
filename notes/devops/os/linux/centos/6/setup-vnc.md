# Installing VNC Server on CentOS 6

This guide explains how to install and configure VNC (Virtual Network Computing) server on CentOS 6.

## Prerequisites

- Root access to the server
- CentOS 6 installed
- Internet connection for package installation

## Installation Steps

### 1. Install VNC Server

```bash
yum -y install tigervnc-server
```

### 2. Configure VNC for a User

1. Switch to the user account that will use VNC:

```bash
su - <username>
```

2. Set VNC password:

```bash
vncpasswd
```

When prompted, enter and confirm your VNC password.

### 3. Configure VNC Startup Script

1. First, start VNC server to create initial configuration:

```bash
vncserver :1
```

2. Stop the VNC server:

```bash
vncserver -kill :1
```

3. Edit the VNC startup script:

```bash
touch ~/.vnc/xstartup
chmod +x ~/.vnc/xstartup
vi ~/.vnc/xstartup
```

4. Modify the startup script by commenting out `twm &` and adding GNOME session:

```bash
#twm &
exec gnome-session &
```

### 4. Start VNC Server

Start VNC server with custom display settings:

```bash
vncserver :1 -geometry 1600x900 -depth 32
```

## Usage Notes

- The `:1` in the commands represents the display number
- Default VNC port is 5901 (for display :1)
- Geometry setting (800x600) can be adjusted based on your needs
- Color depth of 24 provides full color support

## Common Commands

- Start VNC: `vncserver :1`
- Stop VNC: `vncserver -kill :1`
- List running VNC servers: `vncserver -list`

## Security Considerations

- Always use strong passwords for VNC access
- Consider using SSH tunneling for secure remote access
- Implement firewall rules to restrict VNC access

## Troubleshooting

If you encounter issues:

1. Check VNC server logs in `~/.vnc/`
2. Verify firewall settings
3. Ensure proper permissions on the `.vnc` directory
