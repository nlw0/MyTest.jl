using MyTest: gendata, dofit

xx,yy,psim = gendata()

# result = dofit(xx,yy)
# result

using SnoopCompile
inf_timing = @snoopi dofit(xx,yy)

# pc = SnoopCompile.parcel(inf_timing)
# SnoopCompile.write("/tmp/mytestprecompile", pc)
