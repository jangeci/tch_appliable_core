<?php

// autoload_static.php @generated by Composer

namespace Composer\Autoload;

class ComposerStaticInit8a3a7dc78f5399c3541b957f7552fe8b
{
    public static $prefixLengthsPsr4 = array (
        'F' => 
        array (
            'Faker\\' => 6,
        ),
    );

    public static $prefixDirsPsr4 = array (
        'Faker\\' => 
        array (
            0 => __DIR__ . '/..' . '/fzaninotto/faker/src/Faker',
        ),
    );

    public static $classMap = array (
        'Composer\\InstalledVersions' => __DIR__ . '/..' . '/composer/InstalledVersions.php',
    );

    public static function getInitializer(ClassLoader $loader)
    {
        return \Closure::bind(function () use ($loader) {
            $loader->prefixLengthsPsr4 = ComposerStaticInit8a3a7dc78f5399c3541b957f7552fe8b::$prefixLengthsPsr4;
            $loader->prefixDirsPsr4 = ComposerStaticInit8a3a7dc78f5399c3541b957f7552fe8b::$prefixDirsPsr4;
            $loader->classMap = ComposerStaticInit8a3a7dc78f5399c3541b957f7552fe8b::$classMap;

        }, null, ClassLoader::class);
    }
}
