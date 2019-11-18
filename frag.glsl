const vec4 n1 = vec4(-0.027444022037703, -0.092323445726082, 0.995350795962739, 0.);
const vec4 n2 = vec4( 0.958546250158684, -0.284936986554441, 0., 0.);
const vec4 n3 = vec4( 0.2126, 0.7152, 0.0722, 0.);

vec4 linToS(vec4 linRGB)
{
	return mix(
			vec4(1.055)*pow(linRGB,vec4(1./2.4))-vec4(.055),
			vec4(12.92)*linRGB,
			vec4(lessThan(linRGB,vec4(.0031308)))
	);
}

vec4 sToLin(vec4 sRGB)
{
	return mix(
			pow((sRGB+vec4(.055))/vec4(1.055),vec4(2.4)),
			sRGB/vec4(12.92),
			vec4(lessThan(sRGB,vec4(.04045)))
	);
}

vec4 getCubeHelix (vec4 value)
{
	vec4 lin = vec4(value.z);
	lin += value.x*lin*(vec4(1.)-lin) * (cos(value.y)*n1 + sin(value.y)*n2);
	lin.w = value.w;

	return clamp(linToS(lin),vec4(0.),vec4(1.));
}

vec4 toCubeHelix (vec4 color)
{
	vec4 cbH = vec4(0.);
	color = sToLin(color);
	cbH.w = color.w;
	cbH.z = dot(color, n3);
	color -= vec4(cbH.z);
	float a1 = dot(color,n1);
	float a2 = dot(color,n2);
	cbH.y = atan(a2,a1);
	cbH.x = length(vec2(a1,a2))/cbH.z/(1.-cbH.z);

	return cbH;
}

vec4 greyScale (vec4 color)
{
	color = sToLin(color);
	return vec4(linToS(vec4(dot(color,n3))).xyz,1.);
}