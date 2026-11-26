(
var support = Platform.userAppSupportDir;
var flag = support +/+ "use-tidal";

if(File.exists(flag)) {
    (support +/+ "startup.tidal.scd").load;
} {
    (support +/+ "startup.normal.scd").load;
};
)