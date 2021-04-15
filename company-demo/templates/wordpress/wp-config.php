<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', '{{mysql_db}}');

/** MySQL database username */
define('DB_USER', '{{mysql_user}}');

/** MySQL database password */
define('DB_PASSWORD', '{{mysql_password}}');

/** MySQL hostname */
define('DB_HOST', '{{mysql_host}}');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8mb4');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '{U:l_s;>.6&AA{>R!&r?Z+Z;,}Y<}AE:zlYF0RX/yyDq4(4kP@>Rk7W&eiGs+{:t');
define('SECURE_AUTH_KEY',  'VsdSHsy4Vny,};Wg>Fy*GL!zHULTlL=T&OEs?$[s0xF$jHA5twT2yiF4:a@<Nt12');
define('LOGGED_IN_KEY',    'rQ~mV^`</qkPakVR#2lC5%W<-A(|v.=e%o${u/ZK3j!>X.PQw ^K/6)J#kKF`U)X');
define('NONCE_KEY',        '9L53-ssPM5)vE)xm.n:!5]}j%s=3pW#r<z_@|Q9f+dANb :0@.u&/XIeAwc[F(c~');
define('AUTH_SALT',        '=qU?t9.au&puJmT*aB>Vxlf7IFK2gY^[>IxN?7.u!]<35iWxqY8TQ!p9q<i@2)jQ');
define('SECURE_AUTH_SALT', 'r@!^3afP/I]x>HZd>#[L|4Yu5GulexT|BI;n!0~A/FA2H56mjC9~jw:W|zN9ma{$');
define('LOGGED_IN_SALT',   'j{U#BRq{f.31z|87?qH>qUQ-;quI]W=.g-]FZoV:a^Ch9vQjzb5Ht2FWx&:+]&QI');
define('NONCE_SALT',       ']XXA{/sn5v4<zR3MeV**Y0vvW2n%Ph4G!vpA^enh1Sp!DE2(ZM>&h8:EDjF N:|5');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
