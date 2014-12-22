unit Log;

interface

procedure StartProfile( Filename: string );
procedure ProfileEvent( Event: string );

implementation

var
  ProfileFilename: string;

procedure StartProfile( Filename: string );
var
  ProfileFile: TextFile;
begin
  ProfileFilename := Filename;
  Assign( ProfileFile, Filename );
  Rewrite( ProfileFile );
  WriteLn( ProfileFile,
           'Log start' );
  Close( ProfileFile );
end;

procedure ProfileEvent( Event: string );
var
  ProfileFile: TextFile;
begin
  Assign( ProfileFile, ProfileFilename );
  Append( ProfileFile );
  WriteLn( ProfileFile,
           Event );

  Close( ProfileFile );
end;

end.